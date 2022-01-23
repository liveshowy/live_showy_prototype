defmodule LiveShowyWeb.Components.OctaveControl do
  use Phoenix.Component

  def buttons(assigns) do
    ~H"""
    <div class="flex items-center gap-1 py-2">
      <span class="">Octave: <%= @octave %></span>

      <button type="button" phx-click="octave-increment" class="flex w-8 h-8 font-bold text-white bg-default-700 rounded-full place-items-center place-content-center">+</button>
      <button type="button" phx-click="octave-decrement" class="flex w-8 h-8 font-bold text-white bg-default-700 rounded-full place-items-center place-content-center">−</button>
    </div>
    """
  end
end
