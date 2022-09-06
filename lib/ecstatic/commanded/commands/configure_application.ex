defmodule Ecstatic.Commanded.Commands.ConfigureApplication do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :configuration, Ecstatic.Application.Configuration.t()
    field :systems, map(), default: %{} # TODO: remove
  end
end
