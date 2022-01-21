defmodule LiveShowyWeb.Components.Card do
  @moduledoc false
  use Surface.Component

  prop class, :css_class, default: ""
  prop rounded, :string, default: "rounded"
  prop shadow, :string, default: "shadow"
  prop padding, :css_class, default: "p-4"
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
        "min-w-min overflow-hidden w-full h-full",
        @class,
        @rounded,
        @shadow,
        @padding,
        "bg-brand-800": !@transparent,
        "flex flex-wrap gap-2 items-baseline justify-between": @compact,
        "flex flex-col gap-1": !@compact
      }
      {...@attrs}
    >
      <#slot name="header" />

      <div class="flex-1 overflow-auto">
        <#slot name="body" />
      </div>

      <#slot name="footer" />
    </div>
    """
  end
end
