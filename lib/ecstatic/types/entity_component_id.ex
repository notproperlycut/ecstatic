defmodule Ecstatic.Types.EntityComponentId do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  use TypedStruct

  typedstruct do
    field :application, Ecstatic.Types.ApplicationId.t(), enforce: true
    field :component, String.t(), enforce: true
    field :entity, String.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl String.Chars, for: Ecstatic.Types.EntityComponentId do
  # TODO: Do better here
  def to_string(value), do: "#{value.application}.#{value.component}.#{value.entity}"
end
