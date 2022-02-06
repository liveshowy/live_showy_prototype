defmodule LiveShowyWeb.Components.LatencyMonitor do
  @moduledoc """
  Displays latency in milliseconds as reported by the client.
  """
  use LiveShowyWeb, :live_component

  data latency, :integer, default: nil

  def handle_event("ping", _timestamp, socket) do
    {:noreply, socket}
  end

  def handle_event("latency", latency, socket) do
    {:noreply, assign(socket, :latency, latency)}
  end

  def render(assigns) do
    ~F"""
    <span id="latency-monitor" phx-hook="MonitorLatency">
      {@latency}ms
    </span>
    """
  end
end
