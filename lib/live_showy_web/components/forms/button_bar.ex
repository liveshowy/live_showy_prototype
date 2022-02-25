defmodule LiveShowyWeb.Components.Forms.ButtonBar do
  @moduledoc false
  use Surface.Component

  slot default, required: true

  def render(assigns) do
    ~F"""
    <div class="flex gap-0 button-bar">
      <#slot />
    </div>
    """
  end
end
