defmodule Ecstatic.Types.Schema do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct

  typedstruct do
    field :json_schema, map(), enforce: true
  end
end
