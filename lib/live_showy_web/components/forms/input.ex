defmodule LiveShowyWeb.Components.Forms.Input do
  @moduledoc false
  use Surface.Component

  prop attrs, :map, default: %{}
  prop class, :css_class
  prop disabled, :boolean
  prop max, :string
  prop min, :string
  prop name, :string, required: true
  prop placeholder, :string
  prop readonly, :boolean
  prop step, :integer
  prop type, :string, default: "text"
  prop value, :any, required: true

  def render(assigns) do
    ~F"""
    <input
      {...@attrs}
      {=@disabled}
      {=@max}
      {=@min}
      {=@name}
      {=@placeholder}
      {=@readonly}
      {=@step}
      {=@type}
      {=@value}
      class={
        "bg-transparent transition placeholder:text-default-500 focus:bg-white read-only:text-default-500 disabled:text-default-500 read-only:cursor-not-allowed disabled:cursor-not-allowed dark:focus:bg-default-900 rounded-sm flex-grow font-mono px-1 py-0.5",
        @class
      }
      />
    """
  end
end
