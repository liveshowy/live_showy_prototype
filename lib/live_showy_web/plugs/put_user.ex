defmodule LiveShowyWeb.Plugs.PutUser do
  @moduledoc """
  Puts a fake user in the conn if no user has been set.
  """
  import Plug.Conn

  def init(conn), do: conn

  def call(conn, _opts) do
    with current_user_id <- get_session(conn, "current_user_id"),
         %{id: ^current_user_id, username: username} <- LiveShowy.Users.get(current_user_id) do
      conn
      |> assign(:current_user_id, current_user_id)
      |> assign(:username, username)
    else
      _ ->
        delete_session(conn, "current_user_id")
        %{id: user_id, username: username} = LiveShowy.Users.add()

        conn
        |> put_session(:current_user_id, user_id)
        |> assign(:current_user_id, user_id)
        |> assign(:username, username)
    end
  end
end
