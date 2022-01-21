defmodule LiveShowyWeb.Components.DrumPad do
  @moduledoc """
  A user interface for drum and other rhythmic instruments
  """
  use Phoenix.Component

  def grid(assigns) do
    ~H"""
    <div class="inline-grid grid-cols-4 gap-1 auto-rows-fr place-self-center place-content-center place-items-stretch">
      <.single_pad label="kick 1" note={36} />
      <.single_pad label="kick 2" note={37} />
      <.single_pad label="snare 1" note={38} />
      <.single_pad label="snare 2" note={39} />
      <.single_pad label="hh closed 1" note={40} />
      <.single_pad label="hh closed 2" note={41} />
      <.single_pad label="hh open 1" note={42} />
      <.single_pad label="hh open 2" note={43} />
      <.single_pad label="tom hi 1" note={44} />
      <.single_pad label="tom hi 2" note={45} />
      <.single_pad label="tom low 1" note={46} />
      <.single_pad label="tom low 2" note={47} />
    </div>
    """
  end

  defp single_pad(assigns) do
    ~H"""
    <button
      type="button"
      disabled={if @note == nil, do: "disabled"}
      value={@note}
      id={"drum-pad-pad-#{@note}"}
      phx-hook="HandleDrumPadPresses"
      class="p-2 text-xs uppercase break-words duration-150 md:text-base lg:text-lg aspect-square min-w-12 max-w-32 bg-gradient-to-b from-brand-600 to-brand-700 transition-color rounded-xl active:bg-brand-700"
    >
      <%= @label %>
    </button>
    """
  end
end
