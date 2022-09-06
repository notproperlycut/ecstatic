defmodule Ecstatic.Types.Trigger do
  @derive Jason.Encoder
  use TypedStruct

  typedstruct do
    field :component, String.t(), enforce: true
  end
end
