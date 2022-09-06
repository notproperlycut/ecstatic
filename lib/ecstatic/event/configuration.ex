defmodule Ecstatic.Event.Configuration do
  use TypedStruct

  typedstruct do
    field :component, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :schema, Ecstatic.Types.Schema.t(), enforce: true
    field :handler, Ecstatic.Types.Handler.t(), enforce: true
  end
end
