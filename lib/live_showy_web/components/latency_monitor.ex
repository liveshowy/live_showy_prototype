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
    <div id={@id} phx-hook="MonitorLatency">
      {#if @latency}
        <span>
          {@latency}ms
        </span>
      {#else}
        <span class="text-default-500">?ms</span>
      {/if}
    </div>
    """
  end
end
