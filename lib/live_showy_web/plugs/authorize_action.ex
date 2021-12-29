defmodule LiveShowyWeb.Plugs.AuthorizeAction do
  @moduledoc """
  Permits or denies a user action based on the user's role.
  """
  import Plug.Conn

  @roles Application.get_env(:live_showy, :roles)

  def init(conn), do: conn

  def call(conn, role_name) do
    permitted_usernames = @roles[role_name]

    current_user =
      get_session(conn, "current_user_id")
      |> LiveShowy.Users.get_user()

    case current_user.username in permitted_usernames do
      true ->
        conn

      _ ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Not allowed")
        |> Phoenix.Controller.redirect(to: "/")
    end
  end
end
