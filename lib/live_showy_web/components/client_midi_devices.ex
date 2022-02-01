defmodule LiveShowyWeb.Components.ClientMidiDevices do
  @moduledoc false
  require Logger
  use LiveShowyWeb, :live_component
  alias LiveShowyWeb.Components.ClientMidiDevice

  prop current_user_id, :string
  data webmidi_supported?, :boolean, default: nil
  data client_inputs, :map, default: %{}

  def mount(socket) do
    {:ok, midi_output_pid} = PortMidi.open(:output, "IAC Device Bus 1")
    {:ok, assign(socket, midi_output_pid: midi_output_pid)}
  end

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
      <div>
        {#for {_id, device} <- @client_inputs}
          <ClientMidiDevice
            id={device["id"]}
            connection={device["connection"]}
            manufacturer={device["manufacturer"]}
            name={device["name"]}
            state={device["state"]}
            type={device["type"]}
            active_notes={device["active_notes"]}
          />
        {/for}
      </div>
    </div>
    """
  end

  def handle_event("webmidi-supported", boolean, socket) do
    {:noreply, assign(socket, :webmidi_supported?, boolean)}
  end

  def handle_event(
        "midi-device-change",
        %{"id" => device_id, "state" => state, "type" => type} = device,
        socket
      ) do
    case {state, type} do
      {"connected", "input"} ->
        device = Map.put_new(device, "active_notes", MapSet.new())

        {:noreply, update(socket, :client_inputs, &Map.put_new(&1, device_id, device))}

      {_, "input"} ->
        {:noreply,
         update(
           socket,
           :client_inputs,
           &Map.delete(&1, device_id)
         )}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event(
        "midi-message",
        %{"device_id" => device_id, "message" => [status, note, velocity]},
        %{assigns: %{midi_output_pid: midi_output_pid}} = socket
      ) do
    PortMidi.write(midi_output_pid, {status, note, velocity})

    cond do
      status in [176, 224] ->
        # CC and Pitch Bend
        send_update_after(
          __MODULE__,
          [
            id: socket.assigns.id,
            client_inputs:
              update_active_notes(socket.assigns.client_inputs, device_id, note, :delete)
          ],
          250
        )

        socket =
          update(
            socket,
            :client_inputs,
            &update_active_notes(&1, device_id, note, :put)
          )

        {:noreply, socket}

      # NoteOff
      velocity in [nil, 0] or status in 128..143 ->
        {:noreply,
         update(
           socket,
           :client_inputs,
           &update_active_notes(&1, device_id, note, :delete)
         )}

      # All other messages
      status ->
        {:noreply,
         update(
           socket,
           :client_inputs,
           &update_active_notes(&1, device_id, note, :put)
         )}
    end
  end

  def handle_event(
        "midi-message",
        %{"message" => [status, note, velocity]},
        %{assigns: %{midi_output_pid: midi_output_pid}} = socket
      ) do
    PortMidi.write(midi_output_pid, {status, note, velocity})
    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    Logger.warn(unknown_event: {__MODULE__, event, params})
    {:noreply, socket}
  end

  defp update_active_notes(inputs, device_id, note, action) when action in [:put, :delete] do
    update_in(
      inputs,
      [device_id],
      &Map.update!(&1, "active_notes", fn notes -> apply(MapSet, action, [notes, note]) end)
    )
  end
end
