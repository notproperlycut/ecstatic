defmodule Ecstatic.Types.Handler do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct
  use Domo, skip_defaults: true

  @type handler :: list()
  typedstruct do
    field :mfa, handler, enforce: true
  end
end
