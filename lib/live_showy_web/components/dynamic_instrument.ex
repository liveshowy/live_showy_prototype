defmodule LiveShowyWeb.Components.DynamicInstrument do
  use Surface.Component
  alias LiveShowyWeb.Components.Keyboard
  alias LiveShowyWeb.Components.DrumPad

  def render(assigns) do
    assigns =
      if is_struct(assigns.instrument) do
        Map.merge(assigns, assigns.instrument)
        |> Map.drop([:instrument])
      else
        assigns
      end

    component = Map.get(assigns, :component)

    case component do
      Keyboard ->
        Keyboard.render(assigns)

      DrumPad ->
        DrumPad.render(assigns)

      nil ->
        ~F"""
        <span class="font-bold text-default-300">Instrument not supported</span>
        """

      _ ->
        ~F"""
        <span class="font-bold text-default-300">Instrument not supported</span>
        """
    end
  end
end
