defmodule Ecstatic.Events.CommandRemoved do
  use Domo, skip_defaults: true
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name
  ]

  @type t() :: %__MODULE__{
          application_id: any(),
          name: String.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
