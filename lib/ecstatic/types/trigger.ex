defmodule Ecstatic.Types.Trigger do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  defstruct [
    :component
  ]

  @type t() :: %__MODULE__{
          component: String.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
