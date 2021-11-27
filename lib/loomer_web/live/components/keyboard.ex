defmodule LoomerWeb.Live.Components.Keyboard do
  use Phoenix.LiveComponent
  alias LoomerWeb.Live.Components.KeyboardKey

  # Create a range of notes from 0 to 126
  # Group notes into octaves (12 notes each)
  # Index each note within the octaves
  # Index the list of octaves
  @notes 0..126
         |> Enum.chunk_every(12)
         |> Enum.map(&Enum.with_index/1)
         |> Enum.with_index()

  def render(%{octave: octave} = assigns) do
    {notes, _index} = @notes |> Enum.at(octave, [])

    ~H"""
    <div>
      <div class="flex gap-1 p-2 pt-0 shadow-lg select-none bg-gradient-to-b from-purple-800 to-purple-600 rounded-xl">
        <%= for {note, index} <- notes do %>
          <.live_component
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

  defp get_key_color(index) do
    case index in [1, 3, 6, 8, 10] do
      true -> :black
      _ -> :white
    end
  end
end
