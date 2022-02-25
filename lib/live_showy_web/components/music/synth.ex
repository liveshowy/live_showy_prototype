defmodule LiveShowyWeb.Components.Music.Synth do
  @moduledoc false
  require Logger
  use Surface.LiveComponent
  alias LiveShowyWeb.Components.Forms.Input

  data attack, :number, default: 0.5
  data decay, :number, default: 0.5
  data sustain, :number, default: 0.5
  data release, :number, default: 0.5

  def render(assigns) do
    ~F"""
    <form id={@id} phx-change="update-envelope" phx-target={@myself} phx-hook="HandleSynth" class="grid grid-cols-2 auto-rows-auto">
      <label for="attack">Attack</label>
      <Input type="range" min="0" max="1" step="0.001" id="attack" name="attack" value={@attack} />

      <label for="decay">Decay</label>
      <Input type="range" min="0" max="1" step="0.001" id="decay" name="decay" value={@decay} />

      <label for="sustain">Sustain</label>
      <Input type="range" min="0" max="1" step="0.001" id="sustain" name="sustain" value={@sustain} />

      <label for="release">Release</label>
      <Input type="range" min="0" max="1" step="0.001" id="release" name="release" value={@release} />
    </form>
    """
  end

  def handle_event("update-envelope", attrs, socket) do
    {:noreply, push_event(socket, "update-tone-envelope", attrs)}
  end

  def handle_event(event, payload, socket) do
    Logger.warn(unknown_event: {__MODULE__, event, payload})
    {:noreply, socket}
  end
end
