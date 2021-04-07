defmodule Ecstatic.Applications.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Ecstatic.Applications.Projectors.Application,
        Ecstatic.Applications.Projectors.System,
        Ecstatic.Applications.Projectors.Command,
        Ecstatic.Applications.Projectors.ComponentType,
        Ecstatic.Applications.Projectors.Event,
        Ecstatic.Applications.Projectors.Family,
        Ecstatic.Applications.Projectors.Subscription
      ],
      strategy: :one_for_one
    )
  end
end
