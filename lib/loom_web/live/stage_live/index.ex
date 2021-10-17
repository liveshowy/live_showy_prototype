defmodule LoomWeb.StageLive.Index do
  use LoomWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :coords, %{"clientX" => 0, "clientY" => 0})}
  end

  @impl true
  def handle_event("touch-event", params, socket) do
    {:noreply, assign(socket, :coords, params)}
  end
end
