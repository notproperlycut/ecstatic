defmodule Ecstatic.Commanded.Commands.ConfigureApplication.Subscriber do
  alias Ecstatic.Commanded.Types

  use TypedStruct

  typedstruct do
    field :trigger, Types.Trigger.t(), enforce: true
    field :handler, Types.Handler.t(), enforce: true
  end

  def empty() do
    %__MODULE__{
      trigger: Types.Trigger.empty(),
      handler: Types.Handler.empty()
    }
  end
end
