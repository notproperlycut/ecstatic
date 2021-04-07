defmodule Ecstatic.Applications.Commands.AddSystem.ComponentType do
  defstruct [
    :name,
    :schema,
    commands: [],
    events: [],
    subscriptions: []
  ]

  alias Ecstatic.Applications.Commands.AddSystem.{
    Command,
    Event,
    Subscription
  }

  use ExConstructor

  def new(data, args \\ []) do
    data = super(data, args)

    %{
      data
      | commands: Enum.map(data.commands, &Command.new/1),
        events: Enum.map(data.events, &Event.new/1),
        subscriptions: Enum.map(data.subscriptions, &Subscription.new/1)
    }
  end
end
