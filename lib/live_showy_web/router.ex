defmodule LiveShowyWeb.Router do
  use LiveShowyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveShowyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :require_user do
    plug LiveShowyWeb.Plugs.PutUser
    plug LiveShowyWeb.Plugs.PutUserToken
  end

  pipeline :authorize_performers do
    plug LiveShowyWeb.Plugs.AuthorizeAction, :backstage_performer
  end

  pipeline :authorize_live_performers do
    plug LiveShowyWeb.Plugs.AuthorizeAction, :mainstage_performer
  end

  pipeline :authorize_stage_managers do
    plug LiveShowyWeb.Plugs.AuthorizeAction, :stage_manager
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveShowyWeb do
    pipe_through [:browser]

    get "/ping", PingController, :ping
  end

  live_session :default, on_mount: {LiveShowyWeb.SessionHooks.InitAssigns, :user} do
    scope "/", LiveShowyWeb do
      pipe_through [:browser, :require_user]

      live "/", LandingLive.Index, :index
      live "/tone", ToneLive.Index, :index
    end

    scope "/backstage", LiveShowyWeb do
      pipe_through [:browser, :require_user, :authorize_performers]

      live "/", BackstageLive.Index, :index
    end

    scope "/mainstage", LiveShowyWeb do
      pipe_through [:browser, :require_user, :authorize_live_performers]

      live "/", StageLive.Index, :index
    end

    scope "/", LiveShowyWeb do
      pipe_through [:browser, :require_user, :authorize_stage_managers]

      live "/stage-manager", StageManagerLive.Index, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveShowyWeb do
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
      pipe_through [:browser, :require_user, :authorize_stage_managers]
      live_dashboard "/dashboard", metrics: LiveShowyWeb.Telemetry
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
end
