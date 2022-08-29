defmodule Ecstatic.Projectors.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      Ecstatic.Projectors.Application,
      Ecstatic.Projectors.Command,
      Ecstatic.Projectors.Component,
      Ecstatic.Projectors.EntityComponent,
      Ecstatic.Projectors.Event,
      Ecstatic.Projectors.Family,
      Ecstatic.Projectors.Subscriber,
      Ecstatic.Projectors.System
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
