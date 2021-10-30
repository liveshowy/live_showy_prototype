defmodule Loomer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LoomerWeb.Telemetry,
      # Start the Users ETS table
      Loomer.Users,
      # Start the PubSub system
      {Phoenix.PubSub, name: Loomer.PubSub},
      # Start the Presence system
      LoomerWeb.Presence,
      # Start the Endpoint (http/https)
      LoomerWeb.Endpoint
      # Start a worker by calling: Loomer.Worker.start_link(arg)
      # {Loomer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Loomer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LoomerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
