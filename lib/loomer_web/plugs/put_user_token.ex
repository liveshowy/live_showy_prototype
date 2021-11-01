defmodule LoomerWeb.Plugs.PutUserToken do
  @moduledoc """
  Puts a token in the session if a user is present.
  """
  import Plug.Conn

  def init(conn), do: conn

  def call(conn, _opts) do
    with current_user_id <- get_session(conn, "current_user_id"),
         token <- Phoenix.Token.sign(conn, "user socket", current_user_id) do
      conn
      |> assign(:user_token, token)
      |> put_session(:live_socket_id, "users_socket:#{token}")
    else
      _ -> conn
    end
  end
end
