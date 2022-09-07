defmodule Ecstatic.Types.Payload do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct

  typedstruct do
    field :json, String.t(), enforce: true
  end
end
