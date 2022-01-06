defmodule LiveShowyWeb.Live.Components.DrumPad do
  @moduledoc """
  A user interface for drum and other rhythmic instruments
  """
  use LiveShowyWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-4 grid-rows-4 gap-1 place-items-center place-content-center">
      <.pad label="kick 1" note={36} />
      <.pad label="kick 2" note={37} />
      <.pad label="snare 1" note={38} />
      <.pad label="snare 2" note={39} />
      <.pad label="hh closed 1" note={40} />
      <.pad label="hh closed 2" note={41} />
      <.pad label="hh open 1" note={42} />
      <.pad label="hh open 2" note={43} />
      <.pad label="tom hi 1" note={44} />
      <.pad label="tom hi 2" note={45} />
      <.pad label="tom low 1" note={46} />
      <.pad label="tom low 2" note={47} />
    </div>
    """
  end

  defp pad(assigns) do
    ~H"""
    <button
      type="button"
      disabled={if @note == nil, do: "disabled"}
      value={@note}
      phx-hook="HandleDrumPadPresses"
      class="w-32 h-32 uppercase duration-150 bg-purple-800 transition-color rounded-xl active:bg-purple-700"
    >
      <%= @label %>
    </button>
    """
  end
end
