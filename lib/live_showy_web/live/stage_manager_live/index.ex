defmodule LiveShowyWeb.StageManagerLive.Index do
  @moduledoc """
  Users with a stage manager role may access this LiveView to coordinate other users and performances.
  """
  use LiveShowyWeb, :live_view
  alias LiveShowy.Users
  alias LiveShowyWeb.Live.Components.Users, as: UsersList
  alias LiveShowyWeb.Live.Components.WifiInfo

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, assign(socket, users: Users.list_with_roles())}
  end

  @impl true
  def handle_info({action, _user}, socket)
      when action in [
             :user_added,
             :user_updated,
             :user_removed,
             :user_role_added,
             :user_role_removed
           ] do
    {:noreply, assign(socket, users: Users.list_with_roles())}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event(event, _params, socket) do
    require Logger
    Logger.warn("UNKNOWN EVENT: #{event}")
    {:noreply, socket}
  end

  defp subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, LiveShowy.Users.get_topic())
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, LiveShowy.UserRoles.get_topic())
  end
end
