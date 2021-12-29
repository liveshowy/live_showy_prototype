defmodule LiveShowyWeb.Plugs.AuthorizeAction do
  @moduledoc """
  Permits or denies a user action based on the user's role.
  """
  import Plug.Conn
  alias LiveShowy.Roles

  def init(conn), do: conn

  def call(conn, role_name) do
    current_user =
      get_session(conn, "current_user_id")
      |> LiveShowy.Users.get_user()

    case current_user.username in Roles.list_role_users(role_name) do
      true ->
        conn

      _ ->
        conn
        |> Phoenix.Controller.put_flash(:error, "You are not authorized to view that page.")
        |> Phoenix.Controller.redirect(to: "/")
    end
  end
end
