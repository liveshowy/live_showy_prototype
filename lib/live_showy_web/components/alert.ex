defmodule LiveShowyWeb.Components.Alert do
  @moduledoc false
  use Surface.Component

  prop flash, :map, default: nil

  def render(assigns) do
    ~F"""
    {#if @flash != %{} }
      <aside class={"rounded shadow-md text-white", "bg-danger-700": @flash["error"], "bg-info-600": @flash["info"]} phx-click="lv:clear-flash" phx-value-key="info">
        <p class="p-4 mx-auto max-w-7xl">{ inspect(@flash, pretty: true) }</p>
      </aside>
    {/if}
    """
  end
end
