defmodule LiveShowyWeb.SessionHooks.InitAssigns do
  @moduledoc """
  Ensures common assigns are applied to all LiveViews attaching to this hook.
  """
  import Phoenix.LiveView
  alias LiveShowy.UserRoles
  alias LiveShowy.UserInstruments

  def on_mount(:user, _params, %{"current_user_id" => current_user_id} = _session, socket) do
    case LiveShowy.Users.get(current_user_id) do
      nil ->
        {:halt, push_redirect(socket, to: "/")}

      user ->
        {:cont, assign_user(socket, user)}
    end
  end

  def on_mount(:default, _params, _session, socket) do
    {:cont, socket}
  end

  defp assign_user(socket, user) do
    current_user =
      user
      |> Map.put_new(:roles, UserRoles.get(user.id))
      |> Map.put_new(
        :assigned_instrument,
        UserInstruments.get(user.id) |> elem(1)
      )

    assign(socket, current_user: current_user)
  end
end
