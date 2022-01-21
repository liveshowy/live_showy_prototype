defmodule LiveShowyWeb.Components.ButtonBar do
  @moduledoc false
  use Surface.Component

  slot default, required: true

  def render(assigns) do
    ~F"""
    <div class="flex divide-x button-bar divide-brand-900">
      <#slot />
    </div>
    """
  end
end
