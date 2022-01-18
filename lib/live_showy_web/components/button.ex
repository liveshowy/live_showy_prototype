defmodule LiveShowyWeb.Components.Button do
  @moduledoc false
  use Surface.Component

  prop type, :string, default: "button", values!: ["button", "submit", "reset"]
  prop rounded_class, :css_class, default: "rounded-sm"
  prop click, :event

  slot default, required: true

  def render(assigns) do
    ~F"""
    <button
      type={@type}
      class={@rounded_class}
      :on-click={@click}
    >
      <#slot />
    </button>
    """
  end
end
