defmodule LiveShowyWeb.Components.Card do
  @moduledoc false
  use Surface.Component

  prop class, :css_class, default: ""
  prop rounded, :string, default: "rounded"
  prop shadow, :string, default: "shadow"
  prop padding, :css_class, default: "p-4"
  prop transparent, :boolean, default: false
  prop attrs, :map, default: %{}

  slot header
  slot body, required: true
  slot footer

  def render(assigns) do
    ~F"""
    <div
      class={
        "min-w-min flex flex-col gap-1 overflow-auto w-full h-full",
        @class,
        @rounded,
        @shadow,
        @padding,
        "bg-brand-800": !@transparent
      }
      {...@attrs}
    >
      <#slot name="header" />
      <#slot name="body" />
      <#slot name="footer" />
    </div>
    """
  end
end
