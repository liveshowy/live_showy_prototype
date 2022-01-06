defmodule LiveShowyWeb.LandingLive.Index do
  @moduledoc """
  The landing page for LiveShowy.
  """
  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Live.Components.WifiInfo
  alias LiveShowyWeb.Live.Components.LatencyMonitor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_info({:wifi_credential_updated, {key, value}}, socket) do
    send_update(WifiInfo, [{key, value}, id: "wifi-info-stage-manager"])
    {:noreply, socket}
  end
end
