defmodule LiveShowyWeb.Components.DynamicInstrument do
  use Surface.Component

  prop instrument, :struct
  prop active, :boolean, default: false

  def render(%{instrument: instrument} = assigns) do
    instrument = Map.from_struct(instrument)
    # FIXME: THIS BREAKS THE CHILD COMPONENTS' ASSIGNS
    assigns = Map.merge(assigns, instrument) |> Map.drop([:instrument])
    component(&instrument.component.render/1, assigns)
  end

  def render(assigns) do
    ~H"""
    <p class="text-right text-default-400">Please select an instrument.</p>
    """
  end
end
