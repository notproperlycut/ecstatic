defmodule Ecstatic.Commanded.Events.FamilyConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :criteria, Types.Criteria.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.FamilyConfigured do
  def decode(%Ecstatic.Commanded.Events.FamilyConfigured{criteria: criteria} = event) do
    %Ecstatic.Commanded.Events.FamilyConfigured{event | criteria: struct(Ecstatic.Commanded.Types.Criteria, criteria)}
  end
end
