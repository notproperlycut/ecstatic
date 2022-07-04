defmodule Ecstatic.Events.FamilyConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :application_id, Types.ApplicationId.t(), enforce: true
    field :name, String.t(), enforce: true
    field :criteria, Types.Criteria.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Events.FamilyConfigured do
  def decode(%Ecstatic.Events.FamilyConfigured{criteria: criteria} = event) do
    %Ecstatic.Events.FamilyConfigured{event | criteria: struct(Ecstatic.Types.Criteria, criteria)}
  end
end
