defmodule LiveShowyWeb.Components.LatencyMonitor do
  @moduledoc """
  Displays latency in milliseconds as reported by the client.
  """
  use LiveShowyWeb, :live_component

  def mount(socket) do
    {:ok, assign(socket, :latency, nil)}
  end

  def handle_event("ping", _timestamp, socket) do
    {:noreply, socket}
  end

  def handle_event("latency", latency, socket) do
    {:noreply, assign(socket, :latency, latency)}
  end

  def render(assigns) do
    ~F"""
    <span id="latency-monitor" phx-hook="MonitorLatency">
      Latency: <strong>{@latency}ms</strong>
    </span>
    """
  end
end
