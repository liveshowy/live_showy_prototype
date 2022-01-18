defmodule LiveShowyWeb.Components.DynamicInstrument do
  use Phoenix.Component
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
        Keyboard.large(assigns)

      DrumPad ->
        DrumPad.grid(assigns)

      nil ->
        ~H"""
        <span class="font-bold text-brand-300">Instrument not supported</span>
        """

      _ ->
        ~H"""
        <span class="font-bold text-brand-300">Instrument not supported</span>
        """
    end
  end
end
