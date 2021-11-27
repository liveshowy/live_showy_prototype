defmodule LoomerWeb.Live.Components.KeyboardKey do
  use Phoenix.LiveComponent

  @default_class "flex items-end justify-center w-20 h-64 p-1 font-bold opacity-60 hover:opacity-75 active:opacity-100 transition-color duration-150 rounded-b-xl"

  defp get_class(:black), do: @default_class <> " bg-black text-white"
  defp get_class(:white), do: @default_class <> " bg-white text-black"

  def render(assigns) do
    ~H"""
    <button
      type="button"
      phx-hook="HandleKeyboardPresses"
      value={@note}
      id={"key-#{@note}"}
      class={get_class(@color)}
    >
      <%= @note %>
    </button>
    """
  end
end
