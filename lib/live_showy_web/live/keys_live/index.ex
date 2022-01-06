defmodule LiveShowyWeb.KeysLive.Index do
  @moduledoc """
  A stage for up to six members to collaborate.
  """
  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Live.Components.OctaveControl
  alias LiveShowyWeb.Live.Components.Keyboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, octave: 5)}
  end

  def handle_event("note-on", [note, velocity], socket) do
    output = LiveShowy.MidiDevices.get_device(:output)
    PortMidi.write(output, {144, note, velocity})
    {:noreply, socket}
  end

  def handle_event("note-off", note, socket) do
    output = LiveShowy.MidiDevices.get_device(:output)
    PortMidi.write(output, {144, note, 0})
    {:noreply, socket}
  end

  def handle_event("octave-increment", _params, socket) do
    {:noreply, update(socket, :octave, &increment_octave/1)}
  end

  def handle_event("octave-decrement", _params, socket) do
    {:noreply, update(socket, :octave, &decrement_octave/1)}
  end

  @impl true
  def handle_event(event, _params, socket) do
    require Logger
    Logger.warn("UNKNOWN EVENT: #{event}")
    {:noreply, socket}
  end

  defp increment_octave(octave) when octave in 0..9, do: octave + 1
  defp increment_octave(octave), do: octave
  defp decrement_octave(octave) when octave in 1..10, do: octave - 1
  defp decrement_octave(octave), do: octave
end
