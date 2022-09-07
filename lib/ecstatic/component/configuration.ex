defmodule Ecstatic.Component.Configuration do
  @derive {Nestru.Decoder, %{schema: Ecstatic.Types.Schema}}
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :system, String.t(), enforce: true
    field :schema, Ecstatic.Types.Schema.t(), enforce: true
  end

  @spec unpack(map()) :: map()
  def unpack(%{}) do
    %{}
  end

  @spec unpack(map(), map()) :: map()
  def unpack(%{"name" => system}, component) do
    {:ok, name} = Ecstatic.Types.Name.long(system, :component, component["name"])
    component = Map.put(component, "name", name)

    commands = component["commands"]
              |> Ecstatic.Application.Configuration.map_to_named_list()
              |> Enum.map(fn f -> Ecstatic.Command.Configuration.unpack(component, f) end)

    events = component["events"]
              |> Ecstatic.Application.Configuration.map_to_named_list()
              |> Enum.map(fn f -> Ecstatic.Event.Configuration.unpack(component, f) end)

    subscribers = component["subscribers"]
              |> Ecstatic.Application.Configuration.map_to_named_list()
              |> Enum.map(fn f -> Ecstatic.Subscriber.Configuration.unpack(component, f) end)

    component
    |> Map.put("system", system)
    |> Map.put("commands", commands)
    |> Map.put("events", events)
    |> Map.put("subscribers", subscribers)
  end
end
