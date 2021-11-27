defmodule LoomerWeb.Live.Components.Keyboard do
  @moduledoc """
  - Create a range of notes from 0 to 126
  - Group notes into octaves (12 notes each)
  - Index each note within the octaves
  - Index the list of octaves
  """
  use Phoenix.LiveComponent

  @notes 0..127
         |> Enum.chunk_every(12)
         |> Enum.map(&Enum.with_index/1)
         |> Enum.with_index()

  @default_class "flex items-end justify-center w-20 h-64 p-1 font-bold transition-color duration-150 rounded-b-xl"

  def update(assigns, socket) do
    {notes, _index} = @notes |> Enum.at(assigns.octave, [])
    {:ok, assign(socket, octave: assigns.octave, notes: notes)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex gap-1 p-2 pt-0 shadow-lg select-none bg-gradient-to-b from-purple-800 to-purple-600 rounded-xl">
        <%= for {note, index} <- @notes do %>
          <.key
            id={"keyboard-key-#{note}"}
            module={KeyboardKey}
            color={get_key_color(index)}
            note={note}
          />
        <% end %>
      </div>
    </div>
    """
  end

  defp get_class(:black),
    do: @default_class <> " bg-gradient-to-b from-gray-800 to-gray-900 text-white active:to-black"

  defp get_class(:white),
    do:
      @default_class <>
        " bg-gradient-to-b from-gray-100 to-white text-black active:to-gray-300"

  defp key(assigns) do
    ~H"""
    <button
      type="button"
      phx-hook="HandleKeyboardPresses"
      value={@note}
      id={"key-#{@note}"}
      class={get_class(@color)}
    ></button>
    """
  end

  defp get_key_color(index) do
    case index in [1, 3, 6, 8, 10] do
      true -> :black
      _ -> :white
    end
  end
end
