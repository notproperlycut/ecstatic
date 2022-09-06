defmodule Ecstatic.Commanded.Events.SubscriberConfigured do
  use Domo, skip_defaults: true
  @derive Jason.Encoder
  alias Ecstatic.Commanded.Types

  use TypedStruct

  typedstruct do
    field :application, String.t(), enforce: true
    field :component, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :trigger, Types.Trigger.t(), enforce: true
    field :handler, Types.Handler.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Events.SubscriberConfigured do
  def decode(%Ecstatic.Commanded.Events.SubscriberConfigured{trigger: trigger, handler: handler} = event) do
    %Ecstatic.Commanded.Events.SubscriberConfigured{
      event
      | trigger: struct(Ecstatic.Commanded.Types.Trigger, trigger),
        handler:
          struct(Ecstatic.Commanded.Types.Handler, handler) |> Commanded.Serialization.JsonDecoder.decode()
    }
  end
end
