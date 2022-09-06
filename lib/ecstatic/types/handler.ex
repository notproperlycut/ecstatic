defmodule Ecstatic.Types.Handler do
  @derive Jason.Encoder
  use TypedStruct

  @type handler :: list()
  typedstruct do
    field :mfa, handler, enforce: true
  end
end
