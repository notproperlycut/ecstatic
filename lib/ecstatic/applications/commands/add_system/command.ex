defmodule Ecstatic.Applications.Commands.AddSystem.Command do
  defstruct [
    :name,
    :schema,
    :handler
  ]

  use ExConstructor

  def new(data, args \\ []) do
    data = super(data, args)

    %{
      data
      | handler: Ecstatic.Applications.Commands.AddSystem.Handler.new(data.handler)
    }
  end
end
