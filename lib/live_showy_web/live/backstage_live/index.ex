defmodule LiveShowyWeb.BackstageLive.Index do
  @moduledoc false
  # FRAMEWORK / APP
  require Logger
  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Presence

  # CORE
  alias LiveShowy.Users
  alias LiveShowy.UserRoles
  alias LiveShowy.Instrument
  alias LiveShowy.UserInstruments

  # COMPONENTS
  alias LiveShowyWeb.Components.Users, as: UsersComponent
  alias LiveShowyWeb.Components.Forms.Button
  alias LiveShowyWeb.Components.Forms.ButtonBar
  alias LiveShowyWeb.Components.Card
  alias LiveShowyWeb.Components.Keyboard
  alias LiveShowyWeb.Components.DynamicInstrument
  alias LiveShowyWeb.Components.ClientMidiDevices
  alias LiveShowyWeb.Components.Music.Synth

  @topic "backstage"

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    if connected?(socket), do: subscribe()

    Presence.track(
      self(),
      @topic,
      current_user.id,
      current_user
    )

    performers =
      Presence.list(@topic)
      |> Enum.map(fn {_user_id, performer} -> List.first(performer[:metas]) end)

    assigned_instrument =
      case UserInstruments.get(current_user.id) do
        {_user_id, nil} ->
          {_user_id, assigned_instrument} =
            UserInstruments.add({current_user.id, Instrument.new(%{component: Keyboard})})

          assigned_instrument

        {_user_id, assigned_instrument} ->
          assigned_instrument
      end

    {:ok,
     assign(
       socket,
       performers: performers,
       assigned_instrument: assigned_instrument
     )}
  end

  defp subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, @topic)
    Users.subscribe()
    UserRoles.subscribe()
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    performers =
      Presence.list(@topic)
      |> Enum.map(fn {_user_id, performer} -> List.first(performer[:metas]) end)

    {:noreply, assign(socket, performers: performers)}
  end

  def handle_info({:user_updated, user}, socket) do
    present_user_metas = Presence.get_by_key(@topic, user.id)[:metas]

    if present_user_metas do
      metas =
        present_user_metas
        |> List.first()
        |> Map.merge(user)

      Presence.update(self(), @topic, metas.id, metas)
    end

    {:noreply, socket}
  end

  def handle_info(
        {:user_role_removed, {user_id, :backstage_performer}},
        %{assigns: %{current_user: current_user}} = socket
      )
      when current_user.id == user_id do
    {
      :noreply,
      socket
      |> clear_flash()
      |> put_flash(:error, "Your performer role has been removed")
      |> push_redirect(to: Routes.landing_index_path(socket, :index))
    }
  end

  def handle_info(message, socket) do
    Logger.warn(unknown_info: {__MODULE__, message})
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "instrument-requested",
        %{"user-id" => user_id, "instrument" => instrument},
        socket
      ) do
    Logger.info(instrument_requested: {user_id, instrument})
    {_user_id, new_instrument} = set_instrument(user_id, instrument)
    {:noreply, assign(socket, assigned_instrument: new_instrument)}
  end

  def handle_event(event, value, socket) do
    Logger.warning(unknown_event: {__MODULE__, event, value})
    {:noreply, socket}
  end

  @instrument_components %{
    "keys" => LiveShowyWeb.Components.Keyboard,
    "midi" => LiveShowyWeb.Components.MidiIndicator,
    "drums" => LiveShowyWeb.Components.DrumPad
  }

  defp set_instrument(user_id, instrument) do
    case Map.get(@instrument_components, instrument) do
      nil ->
        {user_id, nil}

      instrument ->
        UserInstruments.add({
          user_id,
          Instrument.new(%{component: instrument})
        })
    end
  end
end
