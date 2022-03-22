defmodule LiveShowyWeb.StageManagerLive.Index do
  @moduledoc false
  # FRAMEWORK / APP
  require Logger
  use LiveShowyWeb, :live_view

  # CORE
  alias LiveShowy.Users
  alias LiveShowy.Roles
  alias LiveShowy.UserRoles
  alias LiveShowy.UserInstruments
  alias LiveShowy.Wifi

  # COMPONENTS
  alias LiveShowyWeb.Components.Card
  alias LiveShowyWeb.Components.Forms.Button
  alias LiveShowyWeb.Components.Forms.Input
  alias LiveShowyWeb.Components.WifiCard
  alias LiveShowyWeb.Components.Music.Metronome
  alias Surface.Components.Form.Select

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

    roles = Roles.list()

    role_options =
      for role <- roles, role != :stage_manager, into: %{} do
        role_string = Atom.to_string(role)
        pretty_role_string = role_string |> String.upcase() |> String.replace(~r/_/, " ")
        {pretty_role_string, role_string}
      end

    {:ok,
     assign(socket,
       edit_user: nil,
       users: get_users(),
       roles: roles,
       role_options: role_options,
       selected_role: "backstage_performer",
       selected_user_ids: []
     )}
  end

  defp subscribe do
    LiveShowy.Users.subscribe()
    LiveShowy.UserRoles.subscribe()
    LiveShowy.UserInstruments.subscribe()
    LiveShowy.Music.Metronome.subscribe()
    Wifi.subscribe()
  end

  def get_users do
    Users.list(%{
      roles: UserRoles,
      instrument: UserInstruments
    })
  end

  @impl true
  def handle_info({action, _user}, socket)
      when action in [
             :user_added,
             :user_updated,
             :user_removed,
             :user_role_added
           ] do
    {:noreply, assign(socket, users: get_users())}
  end

  def handle_info({:wifi_credential_updated, {key, value}}, socket) do
    send_update(WifiCard, [{key, value}, id: "wifi-info-stage-manager"])
    {:noreply, socket}
  end

  # KICK OUT REVOKED STAGE MANAGER
  def handle_info(
        {:user_role_removed, {user_id, role}},
        %{assigns: %{current_user: current_user}} = socket
      ) do
    if role == :stage_manager && current_user.id == user_id do
      {
        :noreply,
        socket
        |> clear_flash()
        |> put_flash(:error, "Your stage manager role has been removed")
        |> push_redirect(to: Routes.landing_index_path(socket, :index))
      }
    else
      {:noreply, assign(socket, users: get_users())}
    end
  end

  def handle_info({tag, {_user_id, _role}}, socket)
      when tag in [:user_role_added, :user_role_removed] do
    {:noreply, assign(socket, :users, get_users())}
  end

  def handle_info({tag, {_user_id, _instrument}}, socket)
      when tag in [:user_instrument_added, :user_instrument_removed] do
    {:noreply, assign(socket, users: get_users())}
  end

  def handle_info(message, socket)
      when message in [:metronome_running, :metronome_stopped, :metronome_updated] do
    Metronome.refresh("metronome-form")
    {:noreply, socket}
  end

  def handle_info({:metronome_beat, beat}, socket) do
    Metronome.show_beat("metronome-form", beat)
    {:noreply, socket}
  end

  def handle_info(message, socket) do
    Logger.warn(unknown_message: {__MODULE__, message})
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "handle-change",
        %{"_target" => ["selected_role"], "selected_role" => selected_role},
        socket
      ) do
    {:noreply, assign(socket, :selected_role, selected_role)}
  end

  def handle_event(
        "handle-change",
        %{"_target" => ["selected_user_ids"], "selected_user_ids" => selected_user_ids},
        socket
      ) do
    {:noreply, assign(socket, :selected_user_ids, Enum.uniq(selected_user_ids))}
  end

  def handle_event(
        "toggle-user-selection",
        %{"value" => user_id},
        %{assigns: %{selected_user_ids: selected_user_ids}} = socket
      ) do
    if user_id in selected_user_ids do
      {:noreply, update(socket, :selected_user_ids, &(&1 -- [user_id]))}
    else
      {:noreply, update(socket, :selected_user_ids, &(&1 ++ [user_id]))}
    end
  end

  def handle_event("edit-user", %{"value" => user_id}, socket) do
    {:noreply, assign(socket, :edit_user, Users.get(user_id))}
  end

  def handle_event("update-edit-user", %{"username" => username}, socket) do
    {:noreply, update(socket, :edit_user, &Map.put(&1, :username, username))}
  end

  def handle_event(
        "save-edit-user",
        %{"username" => username},
        %{assigns: %{edit_user: edit_user}} = socket
      ) do
    Users.update(edit_user.id, %{username: username})
    {:noreply, assign(socket, :edit_user, nil)}
  end

  def handle_event("clear-edit-user", _params, socket) do
    {:noreply, assign(socket, :edit_user, nil)}
  end

  def handle_event("select-all", _params, %{assigns: %{users: users}} = socket) do
    user_ids = Enum.map(users, & &1.id) |> Enum.uniq()
    {:noreply, assign(socket, :selected_user_ids, user_ids)}
  end

  def handle_event("deselect-all", _params, socket) do
    {:noreply, assign(socket, :selected_user_ids, [])}
  end

  def handle_event(
        "batch-add-role",
        _params,
        %{assigns: %{selected_role: selected_role, selected_user_ids: selected_user_ids}} = socket
      ) do
    selected_role = String.to_existing_atom(selected_role)

    for user_id <- selected_user_ids do
      UserRoles.add({user_id, selected_role})
    end

    {:noreply, socket}
  end

  def handle_event(
        "batch-remove-role",
        _params,
        %{assigns: %{selected_role: selected_role, selected_user_ids: selected_user_ids}} = socket
      ) do
    selected_role = String.to_existing_atom(selected_role)

    for user_id <- selected_user_ids do
      UserRoles.remove({user_id, selected_role})
    end

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

  def handle_event("midi-message", _message, socket) do
    {:noreply, socket}
  end

  def handle_event(event, params, socket) do
    Logger.warning(unknown_event: {__MODULE__, event, params})
    {:noreply, socket}
  end
end
