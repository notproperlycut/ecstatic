defmodule Ecstatic.Commands.ConfigureApplication.Family do
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :criteria, Types.Criteria.t(), enforce: true
  end

  def empty() do
    %__MODULE__{
      criteria: Types.Criteria.empty()
    }
  end
end
