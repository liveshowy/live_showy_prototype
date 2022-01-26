defmodule LiveShowyWeb.LandingLive.Index do
  @moduledoc false
  use LiveShowyWeb, :live_view
  alias LiveShowy.Wifi
  alias LiveShowyWeb.Components.WifiBar

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, socket}
  end

  defp subscribe do
    Wifi.subscribe()
  end

  @impl true
  def handle_info({:wifi_credential_updated, {key, value}}, socket) do
    send_update(WifiBar, [{key, value}, id: "wifi-bar"])
    {:noreply, socket}
  end
end
