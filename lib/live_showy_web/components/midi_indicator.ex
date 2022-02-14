defmodule LiveShowyWeb.Components.MidiIndicator do
  @moduledoc false
  use Surface.Component

  prop active, :boolean, default: false

  def render(assigns) do
    ~F"""
    <div class="flex justify-center p-2" id="midi-indicator">
      <span class={
        "p-4 flex place-items-center place-content-center border-4 w-32 h-32 rounded-full shadow text-lg",
        "bg-success-500 border-success-300 text-white": @active == true,
        "bg-default-200 border-default-400 dark:bg-default-800": !@active
      }>
        MIDI
      </span>
    </div>
    """
  end
end
