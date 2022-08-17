defmodule Ecstatic.Events.CommandStarted do
  @derive Jason.Encoder
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :id, Types.ApplicationId.t(), enforce: true
  end
end
