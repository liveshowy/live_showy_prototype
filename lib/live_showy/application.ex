defmodule LiveShowy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveShowyWeb.Telemetry,
      # Start the Repo
      LiveShowy.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveShowy.PubSub},
      # Start the Wifi ETS table
      LiveShowy.Wifi,
      # Start the Roles ETS table
      LiveShowy.Roles,
      # Start the Users ETS table
      LiveShowy.Users,
      # Start the UserRoles ETS table
      LiveShowy.UserRoles,
      # Start the UserCoordinates ETS table
      LiveShowy.UserCoordinates,
      # Start the UserInstruments ETS table
      LiveShowy.UserInstruments,
      # Start the Midi ETS table
      LiveShowy.MidiDevices,
      # Start the Presence system
      LiveShowyWeb.Presence,
      # Start the Backstage ETS table
      LiveShowy.Chat.Backstage,
      # Start the Endpoint (http/https)
      LiveShowyWeb.Endpoint
      # Start a worker by calling: LiveShowy.Worker.start_link(arg)
      # {LiveShowy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveShowy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveShowyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
