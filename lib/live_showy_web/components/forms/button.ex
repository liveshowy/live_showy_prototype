defmodule LiveShowyWeb.Components.Forms.Button do
  @moduledoc false
  use Surface.Component

  prop active, :boolean, default: false
  prop attrs, :map, default: %{}
  prop class, :css_class, default: ""
  prop click, :event, required: true
  prop disabled, :boolean, default: false

  prop kind, :string,
    default: "primary",
    values!: ~w(default primary success info warning danger)

  prop name, :string
  prop label, :string
  prop rounded, :css_class, default: "rounded"
  prop shadow, :css_class, default: nil
  prop size, :string, values!: ["sm", "base", "lg"], default: "base"
  prop type, :string, default: "button", values!: ~w(button submit reset)
  prop value, :any

  slot default

  def render(assigns) do
    ~F"""
    <button
      {...@attrs}
      {=@disabled}
      {=@name}
      :on-click={@click}
      {=@type}
      {=@value}
      class={
        "uppercase transition select-none ring-2 ring-transparent font-semibold active:translate-y-px focus:outline-none focus:z-50 hover:text-white",
        @class,
        @rounded,
        @shadow,
        "text-white": @active,
        "cursor-not-allowed opacity-70": @disabled,
        "text-xs px-1.5 py-0.5": @size == "sm",
        "text-base px-2 py-1": @size == "base",
        "text-lg px-4 py-2": @size == "lg",
        "hover:bg-default-500 dark:hover:bg-default-600 focus:ring-default-400": @kind == "default",
        "bg-default-500 dark:bg-default-600": @kind == "default" && @active,
        "bg-default-200 text-default-700 dark:bg-default-700 dark:text-white":
          @kind == "default" && !@active,
        "hover:bg-primary-500 dark:hover:bg-primary-600 focus:ring-primary-400": @kind == "primary",
        "bg-primary-500 dark:bg-primary-600": @kind == "primary" && @active,
        "bg-primary-200 text-primary-700 dark:bg-primary-700 dark:text-white":
          @kind == "primary" && !@active,
        "hover:bg-success-500 dark:hover:bg-success-600 focus:ring-success-400": @kind == "success",
        "bg-success-500 dark:bg-success-600": @kind == "success" && @active,
        "bg-success-200 text-success-700 dark:bg-success-700 dark:text-white":
          @kind == "success" && !@active,
        "hover:bg-info-500 dark:hover:bg-info-600 focus:ring-info-400": @kind == "info",
        "bg-info-500 dark:bg-info-600": @kind == "info" && @active,
        "bg-info-200 text-info-700 dark:bg-info-700 dark:text-white": @kind == "info" && !@active,
        "hover:bg-warning-500 dark:hover:bg-warning-600 focus:ring-warning-400": @kind == "warning",
        "bg-warning-500 dark:bg-warning-600": @kind == "warning" && @active,
        "bg-warning-200 text-warning-700 dark:bg-warning-700 dark:text-white":
          @kind == "warning" && !@active,
        "hover:bg-danger-500 dark:hover:bg-danger-600 focus:ring-danger-400": @kind == "danger",
        "bg-danger-500 dark:bg-danger-600": @kind == "danger" && @active,
        "bg-danger-200 text-danger-700 dark:bg-danger-700 dark:text-white":
          @kind == "danger" && !@active
      }
    >
      <#slot>{@label}</#slot>
    </button>
    """
  end
end
