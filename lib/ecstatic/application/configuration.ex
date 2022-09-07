defmodule Ecstatic.Application.Configuration do
  @derive {Nestru.Decoder, %{
    systems: [Ecstatic.System.Configuration],
    families: [Ecstatic.Family.Configuration],
    components: [Ecstatic.Component.Configuration],
    commands: [Ecstatic.Command.Configuration],
    events: [Ecstatic.Event.Configuration],
    subscribers: [Ecstatic.Subscriber.Configuration],
  }}
  use TypedStruct

  typedstruct do
    field :systems, list(Ecstatic.System.Configuration.t()), default: []
    field :families, list(Ecstatic.Family.Configuration.t()), default: []
    field :components, list(Ecstatic.Component.Configuration.t()), default: []
    field :commands, list(Ecstatic.Command.Configuration.t()), default: []
    field :events, list(Ecstatic.Event.Configuration.t()), default: []
    field :subscribers, list(Ecstatic.Subscriber.Configuration.t()), default: []
  end

  @spec unpack(map()) :: {:ok, Ecstatic.Application.Configuration.t()} | {:error, atom()}
  def unpack(%{"systems" => systems}) do
    systems = systems
              |> map_to_named_list()
              |> Enum.map(fn s -> Ecstatic.System.Configuration.unpack(s) end)

    config = %{
      systems: systems,
      families: get_in(systems, [Access.all(), "families"]) |> List.flatten(),
      components: get_in(systems, [Access.all(), "components"]) |> List.flatten(),
      commands: get_in(systems, [Access.all(), "components", Access.all(), "commands"]) |> List.flatten(),
      events: get_in(systems, [Access.all(), "components", Access.all(), "events"]) |> List.flatten(),
      subscribers: get_in(systems, [Access.all(), "components", Access.all(), "subscribers"]) |> List.flatten()
    }

    Nestru.decode_from_map(config, __MODULE__)
  end

  def map_to_named_list(nil) do
    []
  end

  def map_to_named_list(%{} = map) do
    Enum.map(map, fn {k, v} -> Map.put(v, "name", k) end)
  end
end
