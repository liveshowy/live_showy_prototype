defmodule LiveShowyWeb.Plugs.PutFakeUser do
  @moduledoc """
  Puts a fake user in the conn if no user has been set.
  """
  import Plug.Conn

  def init(conn), do: conn

  def call(conn, _opts) do
    with current_user_id <- get_session(conn, "current_user_id"),
         %{id: _user_id} <- LiveShowy.Users.get_user(current_user_id) do
      assign(conn, :current_user_id, current_user_id)
    else
      _ ->
        %{id: user_id} = LiveShowy.Users.put_user(:fake)
        put_session(conn, :current_user_id, user_id)
    end
  end
end
