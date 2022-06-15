defmodule Ecstatic.Events.SubscriberConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder

  defstruct [
    :application_id,
    :name,
    :trigger,
    :handler
  ]

  @type t() :: %__MODULE__{
          application_id: any(),
          name: String.t(),
          trigger: any(),
          handler: any()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
