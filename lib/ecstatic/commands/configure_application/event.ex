defmodule Ecstatic.Commands.ConfigureApplication.Event do
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :schema, Types.Schema.t(), enforce: true
    field :handler, Types.Handler.t(), enforce: true
  end
end
