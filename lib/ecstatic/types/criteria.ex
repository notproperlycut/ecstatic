defmodule Ecstatic.Types.Criteria do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  defstruct [
    :has
  ]

  @type t() :: %__MODULE__{
          has: String.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
