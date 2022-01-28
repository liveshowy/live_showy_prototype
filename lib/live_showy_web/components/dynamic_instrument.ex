defmodule LiveShowyWeb.Components.DynamicInstrument do
  use Surface.Component

  prop instrument, :struct

  def render(%{instrument: instrument} = assigns) do
    assigns = Map.merge(assigns, instrument) |> Map.drop([:instrument])
    component(&instrument.component.render/1, assigns)
  end

  def render(assigns) do
    ~H"""
    <p class="text-right text-default-400">Please select an instrument.</p>
    """
  end
end
