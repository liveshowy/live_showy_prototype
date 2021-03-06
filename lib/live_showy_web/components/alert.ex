defmodule LiveShowyWeb.Components.Alert do
  @moduledoc false
  use Surface.Component
  alias Phoenix.LiveView.JS

  prop flash, :map, default: %{}
  prop class, :css_class, default: ""

  def render(assigns) do
    ~F"""
    <aside
      :if={@flash != %{}}
      id="alert"
      class={
        "animate-fade-in-slide-down w-full lg:rounded shadow-md text-white text-lg p-4 mx-auto max-w-screen-2xl",
        @class,
        "bg-danger-500 dark:bg-danger-700": @flash["error"],
        "bg-info-500 dark:bg-info-700": @flash["info"]
      }
      phx-click={hide_alert()}
      phx-click-away={hide_alert()}
      phx-value-key={if @flash["error"], do: "error", else: "info"}
    >
      <p>{@flash["error"] || @flash["info"]}</p>
    </aside>
    """
  end

  defp hide_alert(js \\ %JS{}) do
    js
    |> JS.hide(to: "#alert", transition: "animate-fade-out-slide-up", time: 100)

    "lv:clear-flash"
  end
end
