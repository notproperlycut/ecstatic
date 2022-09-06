defmodule Ecstatic.Commanded.Projectors.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      Ecstatic.Commanded.Projectors.Application,
      Ecstatic.Commanded.Projectors.Command,
      Ecstatic.Commanded.Projectors.Component,
      Ecstatic.Commanded.Projectors.EntityComponent,
      Ecstatic.Commanded.Projectors.Event,
      Ecstatic.Commanded.Projectors.Family,
      Ecstatic.Commanded.Projectors.Subscriber,
      Ecstatic.Commanded.Projectors.System
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
