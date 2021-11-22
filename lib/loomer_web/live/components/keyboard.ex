defmodule LoomerWeb.Live.Components.Keyboard do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex gap-1 select-none">
      <%= for note <- 0..127 do %>
        <button type="button" phx-hook="HandleKeyboardPresses" id={"key-#{note}"} class="flex items-end justify-center w-16 h-64 p-1 font-bold text-purple-600 bg-white rounded" value={note}>
          <%= note %>
        </button>
      <% end %>
    </div>
    """
  end
end
