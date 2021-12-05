defmodule LiveShowyWeb.Live.Components.OctaveControl do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex items-center gap-1 py-2">
      <span class="">Octave: <%= @octave %></span>

      <button type="button" phx-click="octave-increment" class="flex w-8 h-8 font-bold text-white bg-purple-700 rounded-full place-items-center place-content-center">+</button>
      <button type="button" phx-click="octave-decrement" class="flex w-8 h-8 font-bold text-white bg-purple-700 rounded-full place-items-center place-content-center">−</button>
    </div>
    """
  end
end
