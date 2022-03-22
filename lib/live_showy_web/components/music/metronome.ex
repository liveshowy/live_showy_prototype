defmodule LiveShowyWeb.Components.Music.Metronome do
  @moduledoc false

  # FRAMEWORK / APP
  require Logger
  alias Phoenix.LiveView.JS
  use LiveShowyWeb, :live_component

  # CORE
  alias LiveShowy.Music.Metronome

  # COMPONENTS
  alias LiveShowyWeb.Components.Forms.Input
  alias LiveShowyWeb.Components.Forms.Button

  data metronome, :struct
  data beat, :string

  def mount(socket) do
    {:ok, assign(socket, metronome: Metronome.get(), beat: 1)}
  end

  def update(%{beat: beat} = assigns, socket) do
    JS.transition("bg-success-500", to: "#metronome-beat-indicator", time: 100)

    {
      :ok,
      socket
      |> push_event("metronome-beat", %{beat: beat})
      |> assign(assigns)
    }
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~F"""
    <form
      id={@id}
      phx-change="update-metronome"
      phx-target={@myself}
      phx-throttle="500"
      class="flex flex-wrap items-baseline justify-end gap-1 p-1 text-xs"
    >
      <Input type="hidden" name="running" value={@metronome.running} />

      <span id="metronome-beat-indicator" class="self-center w-2 h-2 rounded-full" />

      <label class="font-bold uppercase" title="Current Beat">BEAT</label>
      <span id="metronome-beat" phx-hook="HandleMetronomeBeats" class="font-mono font-bold">{@beat}</span>

      <span class="w-24 text-center">
        {#if @metronome.running}
          <span class="text-success-500">RUNNING</span>
        {#else}
          <span class="text-default-500">PAUSED</span>
        {/if}
      </span>

      <div>
        <label class="font-bold uppercase" title="Beats Per Minute">BPM</label>
        <Input type="number" name="bpm" value={@metronome.bpm} min="50" max="200" class="w-12" />
      </div>

      <div>
        <label class="font-bold uppercase" title="Time Signature">TS</label>
        <Input
          type="number"
          name="time_signature_top"
          value={@metronome.time_signature_top}
          min="2"
          max="12"
          class="w-8"
        />
        <Input
          type="number"
          name="time_signature_bottom"
          value={@metronome.time_signature_bottom}
          min="4"
          max="12"
          class="w-8"
        />
      </div>

      <div>
        <label class="font-bold uppercase" title="Subdivision">SUB</label>
        <Input
          type="number"
          name="subdivision"
          min="1"
          max="4"
          value={@metronome.subdivision}
          class="w-8"
        />
      </div>

      {#if @metronome.running}
        <Button type="button" name="running" click="stop-metronome" size="sm" class="w-16">STOP</Button>
      {#else}
        <Button type="button" name="running" click="start-metronome" size="sm" class="w-16">START</Button>
      {/if}
    </form>
    """
  end

  def show_beat(id, beat) do
    send_update(__MODULE__, id: id, beat: beat)
  end

  def refresh(id) do
    send_update(__MODULE__, id: id, metronome: Metronome.get())
  end

  @impl true
  def handle_event("refresh", _params, socket) do
    {:noreply, assign(socket, metronome: Metronome.get())}
  end

  def handle_event("start-metronome", _params, socket) do
    Metronome.run()
    {:noreply, assign(socket, metronome: Metronome.get())}
  end

  def handle_event("stop-metronome", _params, socket) do
    Metronome.stop()
    {:noreply, assign(socket, metronome: Metronome.get(), beat: 1)}
  end

  def handle_event("update-metronome", params, socket) do
    new_metronome =
      params
      |> Map.take(Metronome.get_keys(:string))
      |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
      |> Enum.into(%{})
      |> Metronome.update()

    {:noreply, assign(socket, metronome: new_metronome)}
  end

  def handle_event(event, message, socket) do
    Logger.warn(unknown_event: {__MODULE__, event, message})
    {:noreply, socket}
  end
end
