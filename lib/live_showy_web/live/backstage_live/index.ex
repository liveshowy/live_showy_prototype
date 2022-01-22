defmodule LiveShowyWeb.BackstageLive.Index do
  @moduledoc """
  A chat room for coordinating performers and instruments.
  """
  require Logger
  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Presence
  alias LiveShowy.Users
  alias LiveShowy.Chat.Backstage, as: BackstageChat
  alias LiveShowy.Instrument
  alias LiveShowy.UserInstruments
  alias LiveShowyWeb.Components.Users, as: UsersComponent
  alias LiveShowyWeb.Components.Button
  alias LiveShowyWeb.Components.ButtonBar
  alias LiveShowyWeb.Components.Card
  alias LiveShowyWeb.Components.Chat
  alias LiveShowyWeb.Components.DynamicInstrument
  alias LiveShowyWeb.Components.ClientMidiDevices

  @topic "backstage_performers"

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

    {_user_id, assigned_instrument} = UserInstruments.get(current_user.id)

    {:ok,
     assign(socket,
       performers: performers,
       webmidi_supported: nil,
       assigned_instrument: assigned_instrument,
       client_input_devices: [],
       chat_component_id: "backstage-chat",
       playing_devices: MapSet.new()
     )}
  end

  defp subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, @topic)
    Users.subscribe()
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

  def handle_info({event, message}, %{assigns: %{chat_component_id: chat_component_id}} = socket)
      when event in [:message_added, :message_updated] do
    Chat.add_message(chat_component_id, message, socket)
    {:noreply, socket}
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

  def handle_event("webmidi-supported", boolean, socket) do
    {:noreply, assign(socket, webmidi_supported: boolean)}
  end

  def handle_event("midi-device-change", device, socket) do
    # IO.inspect(device, pretty: true)

    case {device["state"], device["connection"]} do
      {"connected", "open"} ->
        {:noreply, update(socket, :client_input_devices, &[device | &1])}

      _ ->
        {:noreply,
         update(
           socket,
           :client_input_devices,
           &Enum.filter(&1, fn listed_device -> listed_device["id"] != device["id"] end)
         )}
    end
  end

  def handle_event(
        "midi-message",
        %{"device_id" => device_id, "message" => [status, _note, velocity]},
        socket
      ) do
    cond do
      velocity == 0 or status in 128..143 ->
        {:noreply, update(socket, :playing_devices, &MapSet.delete(&1, device_id))}

      status ->
        {:noreply, update(socket, :playing_devices, &MapSet.put(&1, device_id))}
    end
  end

  def handle_event(event, value, socket) do
    Logger.warning(unknown_event: {event, value})
    {:noreply, socket}
  end

  defp set_instrument(user_id, instrument) do
    case instrument do
      "keys" ->
        UserInstruments.add(
          {user_id, Instrument.new(%{component: LiveShowyWeb.Components.Keyboard})}
        )

      "voice" ->
        UserInstruments.add(
          {user_id, Instrument.new(%{component: LiveShowyWeb.Components.Keyboard})}
        )

      "drums" ->
        UserInstruments.add(
          {user_id, Instrument.new(%{component: LiveShowyWeb.Components.DrumPad})}
        )

      _ ->
        {user_id, nil}
    end
  end
end
