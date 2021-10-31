defmodule LoomerWeb.Plugs.PutUserToken do
  @moduledoc """
  Puts a token in the session if a user is present.
  """
  import Plug.Conn

  def init(conn), do: conn

  def call(conn, _opts) do
    with current_user_id <- get_session(conn, "current_user_id"),
         token <- Phoenix.Token.sign(conn, "user socket", current_user_id) do
      assign(conn, :user_token, token)
    else
      _ -> conn
    end
  end
end
