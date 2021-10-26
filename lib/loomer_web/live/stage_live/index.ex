defmodule LoomerWeb.StageLive.Index do
  @moduledoc false

  use LoomerWeb, :live_view

  alias LoomerWeb.Presence

  @topic "stage"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

    username = Faker.Internet.user_name()

    Presence.track(
      self(),
      @topic,
      username,
      %{
        x: Enum.random(10..90),
        y: Enum.random(10..90),
        color: "#" <> Faker.Color.rgb_hex(),
        username: username
      }
    )

    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:ok, assign(socket, users: users, current_user: username)}
  end

  @impl true
  def handle_info({:joined, state}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:dot_moved, state}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_event(event, %{"x" => x, "y" => y}, socket)
      when event in ["touch-event", "mouse-event"] do
    current_user = get_current_user(socket)

    metas =
      Presence.get_by_key(@topic, current_user)[:metas]
      |> List.first()
      |> Map.merge(%{x: x, y: y})

    Presence.update(self(), @topic, current_user, metas)
    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    IO.inspect({event, params}, label: "Unmatched Event")
    {:noreply, socket}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Loomer.PubSub, @topic)
  end

  defp get_current_user(%{assigns: %{current_user: current_user}}) do
    current_user
  end
end
