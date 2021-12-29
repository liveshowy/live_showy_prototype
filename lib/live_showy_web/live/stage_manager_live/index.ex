defmodule LiveShowyWeb.StageManagerLive.Index do
  @moduledoc """
  Users with a stage manager role may access this LiveView to coordinate other users and performances.
  """
  use LiveShowyWeb, :live_view
  alias LiveShowy.Users
  alias LiveShowyWeb.Live.Components.Users, as: UsersList

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, assign(socket, users: get_users())}
  end

  @impl true
  def handle_info({action, _user}, socket)
      when action in [:user_added, :user_updated, :user_removed] do
    {:noreply, assign(socket, users: get_users())}
  end

  def handle_info(message, socket) do
    IO.inspect(message, label: "UNKNOWN INFO MESSAGE")
    {:noreply, socket}
  end

  @impl true
  def handle_event(event, _params, socket) do
    IO.inspect(event, label: "UNKNDOWN EVENT")
    {:noreply, socket}
  end

  defp subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, LiveShowy.Users.get_topic())
  end

  defp get_users, do: Users.list_users() |> Enum.map(fn {_id, user} -> user end)
end
