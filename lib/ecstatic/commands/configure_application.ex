defmodule Ecstatic.Commands.ConfigureApplication do
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :id, Types.ApplicationId.t(), enforce: true
    field :systems, map(), default: %{}
  end
end
