defmodule LiveShowyWeb.Components.Card do
  @moduledoc false
  use Surface.Component

  prop class, :css_class, default: ""
  prop rounded, :string, default: "rounded"
  prop shadow, :string, default: "shadow"
  prop padding, :css_class, default: "py-2 px-4"
  prop transparent, :boolean, default: false
  prop compact, :boolean, default: false
  prop attrs, :map, default: %{}

  slot header
  slot body, required: true
  slot footer

  def render(assigns) do
    ~F"""
    <div
      class={
        "min-w-min overflow-hidden w-full h-full max-w-full",
        @class,
        @rounded,
        @shadow,
        @padding,
        "bg-default-800": !@transparent,
        "flex flex-wrap gap-2 items-baseline justify-between": @compact,
        "flex flex-col gap-1": !@compact
      }
      {...@attrs}
    >
      <#slot name="header" />

      <div class={"overflow-auto", "flex-1": !@compact}>
        <#slot name="body" />
      </div>

      <#slot name="footer" />
    </div>
    """
  end
end
