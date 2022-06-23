defmodule Ecstatic.Types.Schema do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  defstruct [
    :json_schema
  ]

  @type t() :: %__MODULE__{
          json_schema: String.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
