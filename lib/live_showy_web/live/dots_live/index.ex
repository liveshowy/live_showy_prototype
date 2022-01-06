defmodule LiveShowyWeb.DotsLive.Index do
  @moduledoc """
  A stage for multiple users to move shapes.
  """

  alias LiveShowy.UserCoordinates
  use LiveShowyWeb, :live_view
  alias LiveShowyWeb.Presence
  alias LiveShowyWeb.Components.Users
  alias LiveShowyWeb.Components.XYPad

  @topic "dots_live"

  @impl true
  def mount(
        _params,
        _session,
        %{assigns: %{current_user: current_user}} = socket
      ) do
    if connected?(socket), do: subscribe()

    current_user_coords = UserCoordinates.get(current_user.id)
    current_user = Map.put(current_user, :coords, current_user_coords)

    Presence.track(
      self(),
      @topic,
      current_user.id,
      current_user
    )

    users =
      Presence.list(@topic)
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    {:ok,
     assign(
       socket,
       users: users,
       current_user: current_user,
       dots: UserCoordinates.list()
     )}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    users =
      Presence.list(@topic) |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_info({:user_updated, user}, socket) do
    present_user_metas = Presence.get_by_key(@topic, user.id)[:metas]

    if present_user_metas do
      metas =
        present_user_metas
        |> List.first()
        |> Map.merge(user)

      Presence.update(self(), @topic, metas.id, metas)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event(event, [x, y], %{assigns: %{current_user: current_user}} = socket)
      when event in ["touch-event", "mouse-event"] do
    UserCoordinates.add(current_user.id, [x, y])

    metas =
      Presence.get_by_key(@topic, current_user.id)[:metas]
      |> List.first()
      |> Map.merge(%{coords: [x, y]})

    Presence.update(self(), @topic, current_user.id, metas)
    {:noreply, socket}
  end

  def handle_event(
        "set-new-color",
        _params,
        %{assigns: %{current_user: current_user}} = socket
      ) do
    metas =
      Presence.get_by_key(@topic, current_user.id)[:metas]
      |> List.first()
      |> Map.merge(%{
        color: "#" <> Faker.Color.rgb_hex()
      })

    LiveShowy.Users.update(current_user.id, metas)
    Presence.update(self(), @topic, current_user.id, metas)
    {:noreply, socket}
  end

  @doc """
  Ignore unmatched events.
  """
  def handle_event(event, _params, socket) do
    require Logger
    Logger.warn("UNKNOWN EVENT: #{event}")
    {:noreply, socket}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, @topic)
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, LiveShowy.Users.get_topic())
  end
end
