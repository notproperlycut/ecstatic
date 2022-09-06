defmodule Ecstatic.Commanded.Commands.ConfigureApplication do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :systems, map(), default: %{}
  end
end
