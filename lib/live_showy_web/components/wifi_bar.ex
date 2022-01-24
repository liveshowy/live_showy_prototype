defmodule LiveShowyWeb.Components.WifiBar do
  @moduledoc false
  use LiveShowyWeb, :live_component
  alias LiveShowy.Wifi
  require Logger

  @impl true
  def mount(socket) do
    [ssid: ssid, password: password, url: url] = Wifi.list()
    {:ok, assign(socket, ssid: ssid, password: password, url: url)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  data ssid, :string
  data password, :string
  data url, :uri

  @impl true
  def render(assigns) do
    ~F"""
    <ul class="flex gap-2">
      <li>
        SSID: <strong>{@ssid}</strong>
      </li>

      <li>
        Password: <strong>{@password}</strong>
      </li>

      <li>
        URL: <strong>{@url}</strong>
      </li>
    </ul>
    """
  end
end
