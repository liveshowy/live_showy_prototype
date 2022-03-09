defmodule LiveShowyWeb.PingController do
  use LiveShowyWeb, :controller

  def ping(conn, _params) do
    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> text("ok")
  end
end
