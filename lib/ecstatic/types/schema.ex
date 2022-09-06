defmodule Ecstatic.Types.Schema do
  @derive Jason.Encoder
  use TypedStruct

  typedstruct do
    field :json_schema, String.t(), enforce: true
  end
end
