defmodule Ecstatic.Events.ApplicationConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Types

  defstruct [:id]

  @type t() :: %__MODULE__{
          id: Types.ApplicationId.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
