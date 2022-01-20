defmodule LiveShowyWeb.Components.Alert do
  @moduledoc false
  use Surface.Component

  prop flash, :map, default: nil

  prop classes, :css_class,
    default:
      "animate-fade-in-slide-down w-full rounded shadow-md text-white p-4 mx-auto max-w-7xl"

  def render(assigns) do
    ~F"""
    {#if @flash != %{} }
      <aside
        class={
          @classes,
          "bg-danger-700": @flash["error"],
          "bg-info-600": @flash["info"]
        }
        phx-click="lv:clear-flash"
        phx-value-key={if @flash["error"], do: "error", else: "info"}
      >
        <p>{ @flash["error"] || @flash["info"] }</p>
      </aside>
    {/if}
    """
  end
end
