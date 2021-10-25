defmodule LoomerWeb.StageLive.Index do
  @moduledoc false

  use LoomerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

    initial_state = [
      x: "50%",
      y: "50%",
      username: Faker.Internet.user_name(),
      color: Faker.Color.rgb_hex()
    ]

    broadcast(:joined, initial_state)
    {:ok, assign(socket, initial_state)}
  end

  @impl true
  def handle_info({:joined, state}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:dot_moved, state}, socket) do
    IO.inspect(state)
    {:noreply, socket}
  end

  @impl true
  def handle_event(event, [x, y], socket)
      when event in ["touch-event", "mouse-event"] do
    new_socket =
      socket
      |> update(:x, fn _ -> x end)
      |> update(:y, fn _ -> y end)

    broadcast(:dot_moved, new_socket.assigns)
    {:noreply, new_socket}
  end

  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Loomer.PubSub, "stage")
  end

  defp broadcast(event, state) do
    Phoenix.PubSub.broadcast(Loomer.PubSub, "stage", {event, state})
  end
end
