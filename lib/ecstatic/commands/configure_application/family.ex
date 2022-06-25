defmodule Ecstatic.Commands.ConfigureApplication.Family do
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :criteria, Types.Criteria.t(), enforce: true
  end
end
