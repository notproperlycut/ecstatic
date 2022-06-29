defmodule Ecstatic.Events.SubscriberConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Types

  use TypedStruct

  typedstruct do
    field :application_id, Types.ApplicationId.t(), enforce: true
    field :name, String.t(), enforce: true
    field :trigger, Types.Trigger.t(), enforce: true
    field :handler, Types.Handler.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Events.SubscriberConfigured do
  def decode(%Ecstatic.Events.SubscriberConfigured{trigger: trigger, handler: handler} = event) do
    %Ecstatic.Events.SubscriberConfigured{
      event
      | trigger: struct(Ecstatic.Types.Trigger, trigger),
        handler:
          struct(Ecstatic.Types.Handler, handler) |> Commanded.Serialization.JsonDecoder.decode()
    }
  end
end
