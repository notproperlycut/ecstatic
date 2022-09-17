defmodule Ecstatic.Commanded.Commands.Application.Configure do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :configuration, Ecstatic.Application.Configuration.t()
  end
end
