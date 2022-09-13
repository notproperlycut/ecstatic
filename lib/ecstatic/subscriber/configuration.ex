defmodule Ecstatic.Subscriber.Configuration do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{trigger: Ecstatic.Types.Trigger, handler: Ecstatic.Types.Handler}}
  use TypedStruct
  use Domo, skip_defaults: true

  typedstruct do
    field :component, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :trigger, Ecstatic.Types.Trigger.t(), enforce: true
    field :handler, Ecstatic.Types.Handler.t(), enforce: true
  end

  precond(
    t: fn t ->
      %{system: parent_system} = Ecstatic.Types.Name.classify(t.component)
      %{system: system, class: class} = Ecstatic.Types.Name.classify(t.name)
      class == :subscriber && system == parent_system
    end
  )

  @spec unpack(map(), map()) :: map()
  def unpack(%{"name" => component}, subscriber) do
    {:ok, name} = Ecstatic.Types.Name.long(component, :subscriber, subscriber["name"])
    trigger = Ecstatic.Types.Trigger.unpack(subscriber, subscriber["trigger"])

    subscriber
    |> Map.put("component", component)
    |> Map.put("name", name)
    |> Map.put("trigger", trigger)
  end
end
