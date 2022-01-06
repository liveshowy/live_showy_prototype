defmodule LiveShowyWeb.Live.Components.WifiCard do
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

  @impl true
  def render(assigns) do
    ~H"""
    <dl class="grid grid-cols-2 gap-1">
      <dt class="font-bold text-purple-300 uppercase">SSID</dt>
      <dd><%= @ssid %></dd>

      <dt class="font-bold text-purple-300 uppercase">Password</dt>
      <dd><%= @password %></dd>

      <dt class="font-bold text-purple-300 uppercase">URL</dt>
      <dd><%= @url %></dd>
      </dl>
    """
  end
end
