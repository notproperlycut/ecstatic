defmodule Ecstatic.System.Configuration do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
  end
end
