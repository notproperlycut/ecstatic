defmodule Ecstatic.Event.State do
  use TypedStruct

  typedstruct do
    field :status, atom()
  end
end
