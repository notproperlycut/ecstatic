defmodule Ecstatic.Types.Handler do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  defstruct [
    :mfa
  ]

  @type t() :: %__MODULE__{
          mfa: String.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
