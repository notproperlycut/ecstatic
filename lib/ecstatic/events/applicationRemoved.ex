defmodule Ecstatic.Events.ApplicationRemoved do
  use Domo, skip_defaults: true
  @derive Jason.Encoder

  defstruct [:id]

  @type t() :: %__MODULE__{
          id: any()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
