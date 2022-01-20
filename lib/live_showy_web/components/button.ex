defmodule LiveShowyWeb.Components.Button do
  @moduledoc false
  use Surface.Component

  prop click, :event
  prop value, :any
  prop label, :string
  prop type, :string, default: "button", values!: ["button", "submit", "reset"]
  prop attrs, :map, default: %{}

  prop class, :css_class,
    default: "px-2 py-1 uppercase transition font-bold bg-brand-700 hover:bg-brand-600"

  prop rounded, :css_class, default: "rounded"
  prop shadow, :css_class, default: "shadow"

  slot default

  def render(assigns) do
    ~F"""
    <button
      type={@type}
      class={@class, @rounded, @shadow}
      :on-click={@click}
      value={@value}
      {...@attrs}
    >
      <#slot>{@label}</#slot>
    </button>
    """
  end
end
