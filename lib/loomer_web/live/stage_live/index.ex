defmodule LoomerWeb.StageLive.Index do
  @moduledoc """
  LiveView for multi-user interactions on a `stage`.
  """

  use LoomerWeb, :live_view
  alias LoomerWeb.Presence

  @topic "stage"

  @impl true
  def mount(_params, _session, %{assigns: %{current_user_id: current_user_id}} = socket) do
    if connected?(socket), do: subscribe()
    current_user = Loomer.Users.get_user(current_user_id)

    Presence.track(
      self(),
      @topic,
      current_user.id,
      current_user
      |> Map.merge(%{
        x: Enum.random(10..90) |> Integer.to_string() |> String.pad_leading(3, "0"),
        y: Enum.random(10..90) |> Integer.to_string() |> String.pad_leading(3, "0"),
        color: "#" <> Faker.Color.rgb_hex()
      })
    )

    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:ok, assign(socket, users: users, current_username: current_user.username)}
  end

  # TODO: HANDLE LEAVING USERS, SET :last_active TIMESTAMP FOR ETS CLEANUP WORKER?
  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
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

    Presence.update(self(), @topic, current_user_id, metas)
    {:noreply, socket}
  end

  def handle_event(_event, _params, socket) do
    # TODO: Log unmatched events?
    # IO.inspect({event, params}, label: "Unmatched Event")
    {:noreply, socket}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Loomer.PubSub, @topic)
  end
end
