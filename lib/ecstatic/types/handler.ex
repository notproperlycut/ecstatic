defmodule Ecstatic.Types.Handler do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct

  @type handler :: list()
  typedstruct do
    field :mfa, handler, enforce: true
  end
end
