defmodule LiveShowyWeb.Components.Tag do
  @moduledoc false
  use Surface.Component

  prop kind, :atom,
    default: :default,
    values!: [:default, :primary, :brand, :info, :success, :warning, :danger]

  prop class, :css_class
  prop style, :string, default: ""

  slot default, required: true

  def render(assigns) do
    ~F"""
    <span
      class={
        "rounded-full dark:text-white px-3 py-1 shadow",
        @class,
        "text-default-800 bg-default-300 dark:bg-default-700": @kind == :default,
        "text-primary-800 bg-primary-300 dark:bg-primary-700": @kind == :primary,
        "text-brand-800 bg-brand-300 dark:bg-brand-700": @kind == :brand,
        "text-info-800 bg-info-300 dark:bg-info-700": @kind == :info,
        "text-success-800 bg-success-300 dark:bg-success-700": @kind == :success,
        "text-warning-800 bg-warning-300 dark:bg-warning-700": @kind == :warning,
        "text-danger-800 bg-danger-300 dark:bg-danger-700": @kind == :danger
      }
      style={@style}
    >
      <#slot />
    </span>
    """
  end
end
