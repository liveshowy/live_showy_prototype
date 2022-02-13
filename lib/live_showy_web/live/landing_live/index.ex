defmodule LiveShowyWeb.LandingLive.Index do
  @moduledoc false
  # FRAMEWORK / APP
  require Logger
  use LiveShowyWeb, :live_view

  # CORE
  alias LiveShowy.Users
  alias LiveShowy.UserRoles
  alias LiveShowy.UserInstruments

  # COMPONENTS
  alias LiveShowyWeb.Components.Logo
  alias LiveShowyWeb.Components.UserCard

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    if connected?(socket), do: subscribe()

    user =
      current_user
      |> Map.put_new(:roles, UserRoles.get(current_user.id))
      |> Map.put_new(:assigned_instrument, UserInstruments.get(current_user.id) |> elem(1))

    {:ok, assign(socket, current_user: user)}
  end

  defp subscribe do
    Users.subscribe()
    UserRoles.subscribe()
  end

  @impl true
  def handle_info(
        {:user_role_added, {user_id, :performer} = _user_role},
        %{assigns: %{current_user: current_user}} = socket
      )
      when current_user.id == user_id do
    {
      :noreply,
      socket
      |> clear_flash()
      |> put_flash(:info, "You have been assigned a performer role.")
      |> push_redirect(to: Routes.backstage_index_path(socket, :index))
    }
  end

  def handle_info(
        {:user_role_added, {user_id, :stage_manager} = _user_role},
        %{assigns: %{current_user: current_user}} = socket
      )
      when current_user.id == user_id do
    {
      :noreply,
      socket
      |> put_flash(:info, "You have been assigned a stage manager role.")
      |> push_redirect(to: Routes.stage_manager_index_path(socket, :index))
    }
  end

  def handle_info(message, socket) do
    Logger.warn(unknown_message: {__MODULE__, message})
    {:noreply, socket}
  end
end
