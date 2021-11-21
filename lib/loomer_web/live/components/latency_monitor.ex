defmodule LoomerWeb.Live.Components.LatencyMonitor do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, :latency, nil)}
  end

  def handle_event("ping", timestamp, socket) do
    {:noreply, socket}
  end

  def handle_event("latency", latency, socket) do
    {:noreply, assign(socket, :latency, latency)}
  end

  def render(assigns) do
    ~H"""
    <span id="latency-monitor" phx-hook="MonitorLatency" class="flex gap-2 font-mono text-xs">
      Latency: <%= @latency %>ms
    </span>
    """
  end
end
