defmodule Ecstatic.Commands.ConfigureApplication.System do
  use TypedStruct

  typedstruct do
    field :components, map(), default: %{}
    field :families, map(), default: %{}
  end

  def empty() do
    %__MODULE__{}
  end
end
