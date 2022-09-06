defmodule Ecstatic.Commanded.Commands.RemoveApplication do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
  end
end
