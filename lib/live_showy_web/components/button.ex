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
        "px-2 py-1 uppercase transition select-none text-white font-bold outline-none outline-offset-0 active:bg-white border-2 focus:outline-2",
        @class,
        @rounded,
        @shadow,

        "border-primary-800 hover:bg-primary-700 hover:border-primary-700 focus:border-white active:text-primary-800": @kind == "primary",
        "bg-primary-800": @kind == "primary" && @active,
        "bg-transparent": @kind == "primary" && !@active,

        "border-default-800 hover:bg-default-700 hover:border-default-700 focus:border-white active:text-default-800": @kind == "default",
        "bg-default-800": @kind == "default" && @active,
        "bg-transparent": @kind == "default" && !@active,

        "border-brand-800 hover:bg-brand-700 hover:border-brand-700 focus:border-white active:text-brand-800": @kind == "brand",
        "bg-brand-800": @kind == "brand" && @active,
        "bg-transparent": @kind == "brand" && !@active,

        "border-info-800 hover:bg-info-700 hover:border-info-700 focus:border-white active:text-info-800": @kind == "info",
        "bg-info-800": @kind == "info" && @active,
        "bg-transparent": @kind == "info" && !@active,

        "border-warning-800 hover:bg-warning-700 hover:border-warning-700 focus:border-white active:text-warning-800": @kind == "warning",
        "bg-warning-800": @kind == "warning" && @active,
        "bg-transparent": @kind == "warning" && !@active,

        "border-success-800 hover:bg-success-700 hover:border-success-700 focus:border-white active:text-success-800": @kind == "success",
        "bg-success-800": @kind == "success" && @active,
        "bg-transparent": @kind == "success" && !@active,

        "border-danger-800 hover:bg-danger-700 hover:border-danger-700 focus:border-white active:text-danger-800": @kind == "danger",
        "bg-danger-800": @kind == "danger" && @active,
        "bg-transparent": @kind == "danger" && !@active
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
