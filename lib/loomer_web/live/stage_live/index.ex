defmodule LoomerWeb.StageLive.Index do
  use LoomerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    coords = %{"clientX" => 0, "clientY" => 0}
    broadcast(:joined, coords)
    {:ok, assign(socket, :coords, coords)}
  end

  @impl true
  def handle_info({:joined, coords}, socket) do
    {:noreply, assign(socket, :coords, coords)}
  end

  @impl true
  def handle_info({:event, coords}, socket) do
    {:noreply, assign(socket, :coords, coords)}
  end

  @impl true
  def handle_event(_event, params, socket) do
    broadcast(:event, params)
    {:noreply, assign(socket, :coords, params)}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Loomer.PubSub, "stage")
  end

  defp broadcast(event, coords) do
    Phoenix.PubSub.broadcast(Loomer.PubSub, "stage", {event, coords})
  end
end
