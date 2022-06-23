defmodule Ecstatic.Events.SubscriberConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Types

  defstruct [
    :application_id,
    :name,
    :trigger,
    :handler
  ]

  @type t() :: %__MODULE__{
          application_id: Types.ApplicationId.t(),
          name: String.t(),
          trigger: Types.Trigger.t(),
          handler: Types.Handler.t()
        }
  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end
