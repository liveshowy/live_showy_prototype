defmodule LiveShowyWeb.Components.Music.Synth do
  @moduledoc false
  require Logger
  use Surface.LiveComponent
  alias LiveShowyWeb.Components.Forms.Input

  data attack, :number, default: 0.01
  data decay, :number, default: 0.5
  data sustain, :number, default: 0.3
  data release, :number, default: 0.2

  def mount(
        %{assigns: %{attack: attack, decay: decay, sustain: sustain, release: release}} = socket
      ) do
    {
      :ok,
      socket
      |> push_event("update-tone-envelope", %{
        attack: attack,
        decay: decay,
        sustain: sustain,
        release: release
      })
    }
  end

  def update(%{midi_message: midi_message} = assigns, socket) do
    {
      :ok,
      socket
      |> push_event("midi-message", %{message: midi_message})
      |> assign(assigns)
    }
  end

  def update(assigns, socket), do: {:ok, assign(socket, assigns)}

  def render(assigns) do
    ~F"""
    <form id={@id} phx-change="update-envelope" phx-throttle="2000" phx-debounce="2000" phx-target={@myself} phx-hook="HandleSynth" class="grid grid-cols-[auto_auto_1fr] gap-x-4 auto-rows-auto items-center">
      <label for="attack-number">Attack</label>
      <span class="font-mono text-xs">{@attack}</span>
      <Input type="range" min="0" max="1" step="0.001" id="attack-range" name="attack" value={@attack} />

      <label for="decay-number">Decay</label>
      <span class="font-mono text-xs">{@decay}</span>
      <Input type="range" min="0" max="1" step="0.001" id="decay-range" name="decay" value={@decay} />

      <label for="sustain-number">Sustain</label>
      <span class="font-mono text-xs">{@sustain}</span>
      <Input type="range" min="0" max="1" step="0.001" id="sustain-range" name="sustain" value={@sustain} />

      <label for="release-number">Release</label>
      <span class="font-mono text-xs">{@release}</span>
      <Input type="range" min="0" max="1" step="0.001" id="release-range" name="release" value={@release} />
    </form>
    """
  end

  def send_message([_status, _note, _velocity] = midi_message, id) do
    send_update(__MODULE__, id: id, midi_message: midi_message)
  end

  def handle_event("update-envelope", envelope, socket) do
    {
      :noreply,
      socket
      |> assign(envelope)
      |> push_event("update-tone-envelope", envelope)
    }
  end

  def handle_event(event, payload, socket) do
    Logger.warn(unknown_event: {__MODULE__, event, payload})
    {:noreply, socket}
  end
end
