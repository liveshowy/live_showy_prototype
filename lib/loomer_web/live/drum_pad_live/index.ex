defmodule LoomerWeb.DrumPadLive.Index do
  @moduledoc """
  A stage for up to six members to collaborate.
  """
  use LoomerWeb, :live_view
  alias LoomerWeb.Live.Components.LatencyMonitor
  alias LoomerWeb.Live.Components.DrumPad

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("note-on", note, socket) do
    output = Loomer.MidiDevices.get_device(:output)
    PortMidi.write(output, {144, note, 100})
    {:noreply, socket}
  end

  def handle_event("note-off", note, socket) do
    output = Loomer.MidiDevices.get_device(:output)
    PortMidi.write(output, {144, note, 0})
    {:noreply, socket}
  end

  @impl true
  def handle_event(event, params, socket) do
    IO.inspect(params, label: event)
    {:noreply, socket}
  end
end
