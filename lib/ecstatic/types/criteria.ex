defmodule Ecstatic.Types.Criteria do
  @derive Jason.Encoder
  use TypedStruct

  typedstruct do
    field :has, String.t(), enforce: true
  end
end
