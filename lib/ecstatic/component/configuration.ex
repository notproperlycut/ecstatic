defmodule Ecstatic.Component.Configuration do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :schema, Ecstatic.Types.Schema.t(), enforce: true
  end
end
