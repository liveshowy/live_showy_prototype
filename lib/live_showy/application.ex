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
      # Start the Users ETS table
      LiveShowy.Users,
      # Start the UserCoordinates ETS table
      LiveShowy.UserCoordinates,
      # Start the Midi ETS table
      LiveShowy.MidiDevices,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveShowy.PubSub},
      # Start the Presence system
      LiveShowyWeb.Presence,
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
