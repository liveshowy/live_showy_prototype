defmodule LiveShowyWeb.Components.ClientMidiDevices do
  @moduledoc false
  require Logger
  use LiveShowyWeb, :live_component

  prop current_user_id, :string
  data webmidi_supported?, :boolean, default: nil
  data client_inputs, :list, default: []
  data playing_inputs, :mapset, default: MapSet.new()
  data current_message, :list, default: [:status, :note, :velocity]

  def render(assigns) do
    ~F"""
    <div id={@id} phx-hook="HandleWebMidiDevices">
      {#case @webmidi_supported?}
      {#match false}
        <span>WebMIDI is NOT supported</span>
      {#match nil}
        <span class="font-mono text-xs text-default-400">Awaiting WebMIDI support...</span>
      {#match true}
      {/case}

      <h3>Inputs</h3>
      <ul>
        {#for device <- @client_inputs}
          <li class="flex items-center gap-2">
            <span class={
              "rounded-full w-4 h-4 shadow-inner",
              "bg-success-500": device["id"] in @playing_inputs,
              "bg-default-600": device["id"] not in @playing_inputs
            } />

            <span>{device["name"]}</span>
          </li>
        {/for}
      </ul>

      <h3>Current Message</h3>
      <pre>{Jason.encode!(@current_message)}</pre>
    </div>
    """
  end

  def handle_event("webmidi-supported", boolean, socket) do
    {:noreply, assign(socket, :webmidi_supported?, boolean)}
  end

  def handle_event("midi-device-change", %{"state" => state, "type" => type} = device, socket) do
    case {state, type} do
      {"connected", "input"} ->
        {:noreply, update(socket, :client_inputs, &Enum.uniq([device | &1]))}

      {_, "input"} ->
        {:noreply,
         update(
           socket,
           :client_inputs,
           &Enum.filter(&1, fn existing_device -> existing_device["id"] != device["id"] end)
         )}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event(
        "midi-message",
        %{"device_id" => device_id, "message" => [status, _note, velocity] = message},
        socket
      ) do
    socket = assign(socket, current_message: message)

    cond do
      status in [176, 224] ->
        # CC and Pitch Bend
        send_update_after(
          __MODULE__,
          [
            id: socket.assigns.id,
            playing_inputs: MapSet.delete(socket.assigns.playing_inputs, device_id)
          ],
          250
        )

        {:noreply, update(socket, :playing_inputs, &MapSet.put(&1, device_id))}

      # NoteOff
      velocity == 0 or status in 128..143 ->
        {:noreply, update(socket, :playing_inputs, &MapSet.delete(&1, device_id))}

      # All other messages
      status ->
        {:noreply, update(socket, :playing_inputs, &MapSet.put(&1, device_id))}
    end
  end

  def handle_event(event, params, socket) do
    Logger.warn(unknown_event: {__MODULE__, event, params})
    {:noreply, socket}
  end
end
