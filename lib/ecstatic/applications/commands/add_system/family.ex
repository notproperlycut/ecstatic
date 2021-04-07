defmodule Ecstatic.Applications.Commands.AddSystem.Family do
  defstruct [
    :name,
    criteria: []
  ]

  use ExConstructor
end

