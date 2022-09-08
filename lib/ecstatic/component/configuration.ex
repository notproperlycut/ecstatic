defmodule Ecstatic.Component.Configuration do
  @derive {Nestru.Decoder, %{schema: Ecstatic.Types.Schema}}
  use TypedStruct
  use Domo, skip_defaults: true

  typedstruct do
    field :name, String.t(), enforce: true
    field :system, String.t(), enforce: true
    field :schema, Ecstatic.Types.Schema.t(), enforce: true
  end

  precond(
    t: fn t ->
      %{name: system_name} = Ecstatic.Types.Name.classify(t.system)
      %{system: system, class: class} = Ecstatic.Types.Name.classify(t.name)
      class == :component && system == system_name
    end
  )

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
