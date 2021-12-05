defmodule LiveShowyWeb.PageController do
  use LiveShowyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
