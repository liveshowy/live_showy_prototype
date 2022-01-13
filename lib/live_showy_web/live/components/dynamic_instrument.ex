defmodule LiveShowyWeb.Components.DynamicInstrument do
  use Phoenix.Component
  alias LiveShowyWeb.Components.Keyboard
  alias LiveShowyWeb.Components.DrumPad

  def render(assigns) do
    instrument = Map.from_struct(assigns.instrument)
    component = get_in(instrument, [:component])
    assigns = Map.merge(assigns, instrument)

    case component do
      Keyboard -> Keyboard.large(assigns)
      DrumPad -> DrumPad.grid(assigns)
      _ ->
        ~H"""
        <span class="font-bold text-purple-300">No instrument</span>
        """
    end
  end
end
