defmodule Ecstatic.Events.FamilyConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Types

  defstruct [
    :application_id,
    :name,
    :criteria
  ]

  @type t() :: %__MODULE__{
          application_id: Types.ApplicationId.t(),
          name: String.t(),
          criteria: Types.Criteria.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
