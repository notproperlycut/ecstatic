defmodule Ecstatic.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Commanded Application
      Ecstatic.App,
      # Start the Ecto repository
      Ecstatic.Repo,
      # Start the Telemetry supervisor
      EcstaticWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ecstatic.PubSub},
      # Start the Endpoint (http/https)
      EcstaticWeb.Endpoint,

      # Start the Engine projector
      Ecstatic.Engines.Supervisor
      # Start a worker by calling: Ecstatic.Worker.start_link(arg)
      # {Ecstatic.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ecstatic.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EcstaticWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
