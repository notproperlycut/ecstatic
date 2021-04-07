defmodule Ecstatic.Applications.Commands.AddSystem do
  defstruct [
    :id,
    :name,
    component_types: [],
    families: []
  ]

  alias Ecstatic.Applications.Commands.AddSystem.{
    ComponentType,
    Family
  }

  use ExConstructor

  def new(data, args \\ []) do
    data = super(data, args)

    %{
      data
      | component_types: Enum.map(data.component_types, &ComponentType.new/1),
        families: Enum.map(data.families, &Family.new/1)
    }
  end
end
