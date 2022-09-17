defmodule Ecstatic.Commanded.Commands.Application.Remove do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
  end
end
