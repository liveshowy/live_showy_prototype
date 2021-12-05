defmodule LiveShowyWeb.DotsLive.Index do
  @moduledoc """
  A stage for multiple users to move shapes.
  """

  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Presence
  alias LiveShowyWeb.Live.Components.LatencyMonitor
  alias LiveShowyWeb.Live.Components.UserCoords
  alias LiveShowyWeb.Live.Components.XYPad

  @topic "dots_live"

  @impl true
  def mount(
        _params,
        _session,
        %{assigns: %{current_user_id: current_user_id}} = socket
      ) do
    if connected?(socket), do: subscribe()
    current_user = LiveShowy.Users.get_user(current_user_id)

    Presence.track(
      self(),
      @topic,
      current_user.id,
      current_user
    )

    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:ok, assign(socket, users: users, current_username: current_user.username)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: _joins, leaves: _leaves}}, socket) do
    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_event(event, [x, y], %{assigns: %{current_user_id: current_user_id}} = socket)
      when event in ["touch-event", "mouse-event"] do
    metas =
      Presence.get_by_key(@topic, current_user_id)[:metas]
      |> List.first()
      |> Map.merge(%{
        x: x |> Integer.to_string() |> String.pad_leading(3, "0"),
        y: y |> Integer.to_string() |> String.pad_leading(3, "0")
      })

    LiveShowy.Users.update_user(current_user_id, metas)

    Presence.update(self(), @topic, current_user_id, metas)
    {:noreply, socket}
  end

  def handle_event(
        "set-new-color",
        _params,
        %{assigns: %{current_user_id: current_user_id}} = socket
      ) do
    metas =
      Presence.get_by_key(@topic, current_user_id)[:metas]
      |> List.first()
      |> Map.merge(%{
        color: "#" <> Faker.Color.rgb_hex()
      })

    LiveShowy.Users.update_user(current_user_id, metas)
    Presence.update(self(), @topic, current_user_id, metas)
    {:noreply, socket}
  end

  @doc """
  Ignore unmatched events.
  """
  def handle_event(_event, _params, socket) do
    {:noreply, socket}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, @topic)
  end
end
