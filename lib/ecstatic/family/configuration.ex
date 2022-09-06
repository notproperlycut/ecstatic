defmodule Ecstatic.Family.Configuration do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :criteria, Ecstatic.Types.Criteria.t(), enforce: true
  end
end
