defmodule Ecstatic.Commands.ConfigureApplication.Command do
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :schema, Types.Schema.t(), enforce: true
    field :handler, Types.Handler.t(), enforce: true
  end

  def empty() do
    %__MODULE__{
      schema: Types.Schema.empty(),
      handler: Types.Handler.empty()
    }
  end
end
