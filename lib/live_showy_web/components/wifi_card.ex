defmodule LiveShowyWeb.Components.WifiCard do
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
    <dl class="grid grid-cols-2 gap-1">
      <dt class="font-bold uppercase text-default-500 dark:text-default-300">SSID</dt>
      <dd>{@ssid}</dd>

      <dt class="font-bold uppercase text-default-500 dark:text-default-300">Password</dt>
      <dd>{@password}</dd>

      <dt class="font-bold uppercase text-default-500 dark:text-default-300">URL</dt>
      <dd>{@url}</dd>
    </dl>
    """
  end
end
