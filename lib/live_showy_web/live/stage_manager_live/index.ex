defmodule LiveShowyWeb.StageManagerLive.Index do
  @moduledoc """
  Users with a stage manager role may access this LiveView to coordinate other users and performances.
  """
  use LiveShowyWeb, :live_view
  alias LiveShowy.Users
  alias LiveShowy.Roles
  alias LiveShowy.UserRoles
  alias LiveShowy.Wifi
  alias LiveShowyWeb.Live.Components.WifiCard

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, assign(socket, users: Users.list_with_roles(), roles: Roles.list())}
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

  def handle_info({:wifi_credential_updated, {key, value}}, socket) do
    send_update(WifiCard, [{key, value}, id: "wifi-info-stage-manager"])
    {:noreply, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  def handle_event("user-role-changed", %{"_target" => [user_id]} = params, socket) do
    roles = params[user_id] |> Enum.map(&String.to_existing_atom/1)
    UserRoles.set({user_id, roles})
    {:noreply, socket}
  end

  def handle_event(
        "add-user-role",
        %{"user-id" => user_id, "role" => role},
        socket
      ) do
    UserRoles.add({user_id, String.to_existing_atom(role)})
    {:noreply, socket}
  end

  def handle_event(
        "remove-user-role",
        %{"user-id" => user_id, "role" => role},
        socket
      ) do
    UserRoles.remove({user_id, String.to_existing_atom(role)})
    {:noreply, socket}
  end

  @impl true
  def handle_event(event, params, socket) do
    require Logger
    Logger.warn("UNKNOWN EVENT: #{event}")
    IO.inspect(params)
    {:noreply, socket}
  end

  defp subscribe do
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, LiveShowy.Users.get_topic())
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, LiveShowy.UserRoles.get_topic())
    Phoenix.PubSub.subscribe(LiveShowy.PubSub, Wifi.get_topic())
  end
end
