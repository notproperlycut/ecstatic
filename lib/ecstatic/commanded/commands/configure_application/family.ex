defmodule Ecstatic.Commanded.Commands.ConfigureApplication.Family do
  alias Ecstatic.Commanded.Types

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
