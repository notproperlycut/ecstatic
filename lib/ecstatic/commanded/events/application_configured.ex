defmodule Ecstatic.Commanded.Events.ApplicationConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder

  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
