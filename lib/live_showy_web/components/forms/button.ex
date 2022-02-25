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
    values!: ~w(primary default)

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
        "hover:bg-primary-500 dark:hover:bg-primary-600 focus:ring-primary-400": @kind == "primary",
        "bg-primary-500 dark:bg-primary-600": @kind == "primary" && @active,
        "bg-primary-200 text-primary-700 dark:bg-primary-800 dark:text-white": @kind == "primary" && !@active
      }
    >
      <#slot>{@label}</#slot>
    </button>
    """
  end
end
