defmodule LiveShowyWeb.UserBarLive.Index do
  @moduledoc false

  # FRAMEWORK / APP
  require Logger
  use LiveShowyWeb, :live_view

  # CORE
  alias LiveShowy.Users
  alias LiveShowy.UserRoles
  alias LiveShowy.UserInstruments

  # COMPONENTS
  alias LiveShowyWeb.Components.LatencyMonitor

  def mount(_params, %{"current_user_id" => current_user_id} = _session, socket) do
    if connected?(socket), do: subscribe()

    {:ok,
     assign(socket,
       current_user: Users.get(current_user_id),
       assigned_instrument: UserInstruments.get(current_user_id) |> elem(1),
       roles: UserRoles.get(current_user_id)
     )}
  end

  defp subscribe() do
    Users.subscribe()
    UserRoles.subscribe()
    UserInstruments.subscribe()
  end

  @impl true
  def handle_info({:user_updated, user}, %{assigns: %{current_user: current_user}} = socket)
      when user.id == current_user.id do
    {:noreply, assign(socket, current_user: user)}
  end

  def handle_info(
        {:user_role_added, {user_id, role}},
        %{assigns: %{current_user: current_user}} = socket
      )
      when user_id == current_user.id do
    {:noreply, update(socket, :roles, &[role | &1])}
  end

  def handle_info(
        {:user_role_removed, {user_id, role}},
        %{assigns: %{current_user: current_user}} = socket
      )
      when user_id == current_user.id do
    {:noreply, update(socket, :roles, &(&1 -- [role]))}
  end

  def handle_info(
        {:user_instrument_added, {user_id, instrument}},
        %{assigns: %{current_user: current_user}} = socket
      )
      when user_id == current_user.id do
    {:noreply, assign(socket, assigned_instrument: instrument)}
  end

  def handle_info(message, socket) do
    Logger.warn(unknown_message: {__MODULE__, message})
    {:noreply, socket}
  end

  defp render_instrument_name(component) when is_atom(component) do
    Atom.to_string(component)
    |> String.replace(~r/.*\.(\w+)$/, "\\g{1}")
  end
end
