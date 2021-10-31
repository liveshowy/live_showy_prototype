defmodule LoomerWeb.Router do
  use LoomerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LoomerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LoomerWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/stage", StageLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LoomerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LoomerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp put_user_token(conn, _opts) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
