defmodule LiveShowyWeb.UserSessionTest do
  use LiveShowyWeb.ConnCase, async: false
  doctest LiveShowy.Users

  test "new user is created on first visit and retained on next visit", %{conn: conn} do
    conn = get(conn, "/")
    new_username = conn.assigns.current_user.username
    assert new_username != nil

    conn = get(conn, "/")
    assert new_username == conn.assigns.current_user.username
  end
end
