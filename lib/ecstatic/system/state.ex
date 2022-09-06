defmodule Ecstatic.System.State do
  use TypedStruct

  typedstruct do
    field :status, atom()
  end
end
