defmodule LiveShowyWeb.Components.Button do
  @moduledoc false
  use Surface.Component

  prop click, :event, required: true
  prop value, :any
  prop label, :string
  prop type, :string, default: "button", values!: ["button", "submit", "reset"]
  prop attrs, :map, default: %{}

  prop class, :css_class, default: ""
  prop active, :boolean, default: false
  prop rounded, :css_class, default: "rounded"
  prop shadow, :css_class, default: "shadow"
  prop uppercase, :boolean, default: true

  slot default

  def render(assigns) do
    ~F"""
    <button
      type={@type}
      class={
        "px-2 py-1 uppercase transition font-bold bg-brand-700 active:bg-white active:text-brand-700 outline-none focus:ring-4 focus:ring-accent-400",
        @class,
        @rounded,
        @shadow,
        uppercase: @uppercase,
        "hover:bg-brand-600": !@active,
        "bg-white text-brand-700 hover:bg-brand-200": @active
      }
      :on-click={@click}
      value={@value}
      {...@attrs}
    >
      <#slot>{@label}</#slot>
    </button>
    """
  end
end
