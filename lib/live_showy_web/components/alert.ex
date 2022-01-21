defmodule LiveShowyWeb.Components.Alert do
  @moduledoc false
  use Surface.Component
  alias Phoenix.LiveView.JS

  prop flash, :map, default: nil

  prop class, :css_class, default: ""

  def render(assigns) do
    ~F"""
    {#if @flash != %{} }
      <aside
        id="alert"
        class={
          "animate-fade-in-slide-down w-full 2xl:rounded shadow-md text-white p-4 mx-auto max-w-screen-2xl",
          @class,
          "bg-danger-700": @flash["error"],
          "bg-info-600": @flash["info"]
        }
        phx-click={hide_alert()}
        phx-click-away={hide_alert()}
        phx-value-key={if @flash["error"], do: "error", else: "info"}
      >
        <p>{ @flash["error"] || @flash["info"] }</p>
      </aside>
    {/if}
    """
  end

  defp hide_alert(js \\ %JS{}) do
    js
    |> JS.hide(to: "#alert", transition: "animate-fade-out-slide-up", time: 100)

    "lv:clear-flash"
  end
end
