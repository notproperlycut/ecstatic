defmodule Ecstatic.Otp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Ecstatic.Commanded.Application,
      Ecstatic.Commanded.Repo,
      Ecstatic.Commanded.Projectors.Supervisor,
      Ecstatic.Commanded.Workflows.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ecstatic.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
