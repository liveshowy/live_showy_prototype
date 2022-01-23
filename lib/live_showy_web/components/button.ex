defmodule LiveShowyWeb.Components.Button do
  @moduledoc false
  use Surface.Component

  prop active, :boolean, default: false
  prop attrs, :map, default: %{}
  prop class, :css_class, default: ""
  prop click, :event, required: true

  prop kind, :string,
    default: "primary",
    values!: ~w(primary default brand info warning success danger)

  prop label, :string
  prop rounded, :css_class, default: "rounded"
  prop shadow, :css_class, default: "shadow"
  prop type, :string, default: "button", values!: ~w(button submit reset)
  prop value, :any

  slot default

  def render(assigns) do
    ~F"""
    <button
      type={@type}
      class={
        "px-2 py-1 uppercase transition font-bold text-white outline-none hover:bg-white focus:outline-2",
        @class,
        @rounded,
        @shadow,
        "bg-primary-700 focus:outline-primary-700 hover:text-primary-700": @kind == "primary",
        "bg-primary-500 focus:outline-primary-500": @kind == "primary" && @active,
        "bg-default-700 focus:outline-default-700 hover:text-default-700": @kind == "default",
        "bg-default-500 focus:outline-default-500": @kind == "default" && @active,
        "bg-brand-700 focus:outline-brand-700 hover:text-brand-700": @kind == "brand",
        "bg-brand-500 focus:outline-brand-500": @kind == "brand" && @active,
        "bg-info-700 focus:outline-info-700 hover:text-info-700": @kind == "info",
        "bg-info-500 focus:outline-info-500": @kind == "info" && @active,
        "bg-warning-700 focus:outline-warning-700 hover:text-warning-700": @kind == "warning",
        "bg-warning-500 focus:outline-warning-500": @kind == "warning" && @active,
        "bg-success-700 focus:outline-success-700 hover:text-success-700": @kind == "success",
        "bg-success-500 focus:outline-success-500": @kind == "success" && @active,
        "bg-danger-700 focus:outline-danger-700 hover:text-danger-700": @kind == "danger",
        "bg-danger-500 focus:outline-danger-500": @kind == "danger" && @active
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
