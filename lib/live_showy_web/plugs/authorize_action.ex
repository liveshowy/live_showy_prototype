defmodule LiveShowyWeb.Plugs.AuthorizeAction do
  @moduledoc """
  Permits or denies a user action based on the user's role.
  """
  import Plug.Conn
  import Phoenix.Controller
  alias LiveShowyWeb.Router.Helpers, as: Routes
  alias LiveShowy.UserRoles

  def init(conn), do: conn

  def call(conn, role_name) do
    case UserRoles.check({get_session(conn, "current_user_id"), role_name}) do
      true ->
        conn

      _ ->
        conn
        |> put_flash(:error, "You are not authorized to view that page.")
        |> redirect(to: Routes.landing_index_path(conn, :index))
        |> halt()
    end
  end
end
