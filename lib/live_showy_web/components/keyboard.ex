defmodule LiveShowyWeb.Components.Keyboard do
  @moduledoc """
  - Create a range of notes from 0 to 126
  - Group notes into octaves (12 notes each)
  - Index each note within the octaves
  - Index the list of octaves
  """
  use Phoenix.Component

  @notes 0..127
         |> Enum.chunk_every(12)
         |> Enum.map(&Enum.with_index/1)
         |> Enum.with_index()

  @note_names Enum.with_index([
                "C",
                "C# | Db",
                "D",
                "D# | Eb",
                "E",
                "F",
                "F# | Gb",
                "G",
                "G# | Ab",
                "A",
                "A# | Bb",
                "B"
              ])

  @default_class "flex flex-col gap-1 items-center justify-end w-20 h-64 p-1 font-bold transition-color duration-150 rounded-b-xl"

  def update(assigns, socket) do
    {notes, _index} = @notes |> Enum.at(assigns.octave, [])
    {:ok, assign(socket, octave: assigns.octave, notes: notes)}
  end

  def large(assigns) do
    {notes, _index} = Enum.at(@notes, assigns.octave, [])

    notes =
      Enum.zip_reduce(notes, @note_names, [], fn {note, note_index}, {label, label_index}, acc ->
        if note_index == label_index do
          [{note, label, note_index} | acc]
        else
          acc
        end
      end)
      |> Enum.reverse()

    assigns = assign(assigns, :notes, notes)

    ~H"""
    <div>
      <div class="flex justify-center gap-1 p-2 pt-0 select-none">
        <%= for {note, label, index} <- @notes do %>
          <.key
            id={"keyboard-key-#{note}"}
            color={get_key_color(index)}
            label={label}
            note={note}
          />
        <% end %>
      </div>
    </div>
    """
  end

  defp get_class(:black) do
    @default_class <>
      " bg-gradient-to-b from-purple-600 to-purple-700 text-white active:to-black"
  end

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
    >
      <span><%= @label %></span>
      <span class="opacity-50"><%= @note %></span>
    </button>
    """
  end

  defp get_note_name(int) do
    @note_names
    |> Enum.find("TBD", fn {_label, index} -> int == index end)
    |> elem(0)
  end

  defp get_key_color(index) do
    case index in [1, 3, 6, 8, 10] do
      true -> :black
      _ -> :white
    end
  end
end
