defmodule LiveShowyWeb.Components.Logo do
  @moduledoc false
  use Surface.Component

  prop class, :css_class
  prop text_size, :css_class, default: "text-6xl"

  def render(assigns) do
    ~F"""
    <span
      class={
        "text-default-700 dark:text-default-100 select-none logo font-logo drop-shadow-lg",
        @class,
        @text_size
      }
    >
      LiveShowy
    </span>
    """
  end
end
