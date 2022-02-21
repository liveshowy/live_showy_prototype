defmodule LiveShowyWeb.Components.Forms.Input do
  @moduledoc false
  use Surface.Component

  prop name, :string, required: true
  prop value, :any, required: true
  prop type, :string, default: "text"
  prop attrs, :map, default: %{}
  prop class, :css_class
  prop min, :string
  prop max, :string

  def render(assigns) do
    ~F"""
    <input
      {=@type}
      {=@value}
      {=@name}
      {=@min}
      {=@max}
      {...@attrs}
      class={
        "bg-transparent transition focus:bg-white dark:focus:bg-default-900 rounded-sm w-auto font-mono px-1 py-0.5",
        @class
      }
      />
    """
  end
end
