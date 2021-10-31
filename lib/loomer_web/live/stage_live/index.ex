defmodule LoomerWeb.StageLive.Index do
  @moduledoc false

  use LoomerWeb, :live_view

  alias LoomerWeb.Presence

  @topic "stage"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

    current_user = socket.assigns[:current_user] || Loomer.Protocols.User.new(:fake)

    user =
      current_user
      |> Map.merge(%{
        x: Enum.random(10..90),
        y: Enum.random(10..90),
        color: "#" <> Faker.Color.rgb_hex()
      })

    Presence.track(
      self(),
      @topic,
      user.username,
      user
    )

    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:ok, assign(socket, users: users, current_user: user.username)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_event(event, [x, y], socket)
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

  defp user_matches?(user, current_user), do: user.username == current_user

  defp get_circle_z_index(user, current_user) do
    case user_matches?(user, current_user) do
      true -> 1000
      _ -> 0
    end
  end
end
