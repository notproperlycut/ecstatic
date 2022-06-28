defmodule Ecstatic.Commands.RemoveApplication do
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :id, Types.ApplicationId.t(), enforce: true
  end
end
