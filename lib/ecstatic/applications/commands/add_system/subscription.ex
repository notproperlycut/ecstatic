defmodule Ecstatic.Applications.Commands.AddSystem.Subscription do
  defstruct [
    :name,
    :trigger,
    :payload,
    :handler
  ]

  use ExConstructor
end
