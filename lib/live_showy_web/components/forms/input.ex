defmodule LiveShowyWeb.Components.Forms.Input do
  @moduledoc false
  use Surface.Component

  prop accent_class, :css_class, default: "accent-primary-500"
  prop attrs, :map, default: %{}
  prop class, :css_class
  prop disabled, :boolean, default: false
  prop id, :string
  prop max, :string
  prop min, :string
  prop name, :string, required: true
  prop placeholder, :string
  prop readonly, :boolean, default: false
  prop step, :integer
  prop type, :string, default: "text"
  prop value, :any, required: true

  def render(assigns) do
    ~F"""
    <input
      {...@attrs}
      {=@disabled}
      {=@id}
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
        @class,
        @accent_class
      }
      />
    """
  end
end
