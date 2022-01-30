defmodule LiveShowyWeb.Components.Button do
  @moduledoc false
  use Surface.Component

  prop active, :boolean, default: false
  prop attrs, :map, default: %{}
  prop class, :css_class, default: ""
  prop click, :event, required: true

  prop kind, :string,
    default: "primary",
    values!: ~w(primary default)

  prop label, :string
  prop rounded, :css_class, default: "rounded"
  prop shadow, :css_class, default: "shadow"
  prop type, :string, default: "button", values!: ~w(button submit reset)
  prop disabled, :boolean, default: false
  prop value, :any

  slot default

  def render(assigns) do
    ~F"""
    <button
      type={@type}
      disabled={@disabled}
      class={
        "px-2 py-1 uppercase transition select-none font-bold focus:bg-white active:translate-y-px focus:outline-none hover:text-white",
        @class,
        @rounded,
        @shadow,
        "text-white": @active,
        "cursor-not-allowed opacity-70": @disabled,
        "hover:bg-primary-500 dark:hover:bg-primary-600  focus:text-primary-600": @kind == "primary",
        "bg-primary-500 dark:bg-primary-700": @kind == "primary" && @active,
        "bg-primary-200 text-primary-700 dark:bg-primary-900 dark:text-white": @kind == "primary" && !@active
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
