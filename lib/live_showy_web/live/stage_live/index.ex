defmodule LiveShowyWeb.StageLive.Index do
  @moduledoc false
  # FRAMEWORK / APP
  require Logger
  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Presence
  alias LiveShowyWeb.Router.Helpers, as: Routes

  # CORE
  alias LiveShowy.Users
  alias LiveShowy.UserRoles
  alias LiveShowy.Instrument
  alias LiveShowy.MidiDevices
  alias LiveShowy.SharedMidiState
  alias LiveShowy.UserInstruments

  # COMPONENTS
  alias LiveShowyWeb.Components.Card
  alias LiveShowyWeb.Components.ClientMidiDevices
  alias LiveShowyWeb.Components.Users, as: UsersComponent
  alias LiveShowyWeb.Components.DynamicInstrument
  alias Surface.Components.Link

  @topic "stage"

  def mount(
        _params,
        _session,
        %{
          assigns: %{
            current_user:
              %{assigned_instrument: %Instrument{} = _assigned_instrument} = current_user
          }
        } = socket
      ) do
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

    {_user_id, assigned_instrument} = UserInstruments.get(current_user.id)

    {:ok,
     assign(socket,
       performers: performers,
       assigned_instrument: assigned_instrument,
       midi_output_pid: MidiDevices.get_device_pid(:output, "IAC Device Bus 1")
     )}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> put_flash(:error, "Please select an instrument")
      |> push_redirect(to: Routes.backstage_index_path(socket, :index))

    {:ok, socket}
  end

  defp subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, @topic)
    Users.subscribe()
    UserRoles.subscribe()
    UserInstruments.subscribe()
  end

  def handle_event(
        "midi-message",
        %{"message" => [status, note, velocity]},
        %{assigns: %{midi_output_pid: midi_output_pid}} = socket
      ) do
    SharedMidiState.write_message(midi_output_pid, {status, note, velocity})
    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    Logger.warn(unknown_event: {__MODULE__, event, params})
    {:noreply, socket}
  end

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

  def handle_info({:user_instrument_added, instrument}, socket) do
    {:noreply, assign(socket, assigned_instrument: instrument)}
  end

  def handle_info(message, socket) do
    Logger.warn(unknown_message: {__MODULE__, message})
    {:noreply, socket}
  end
end
