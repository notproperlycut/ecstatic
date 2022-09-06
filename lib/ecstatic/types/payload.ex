defmodule Ecstatic.Types.Payload do
  @derive Jason.Encoder
  use TypedStruct

  typedstruct do
    field :json, String.t(), enforce: true
  end
end
