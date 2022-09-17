defmodule Ecstatic.Application.Configuration do
  @derive Jason.Encoder
  @derive {Nestru.Decoder, %{
    systems: [Ecstatic.System.Configuration],
    families: [Ecstatic.Family.Configuration],
    components: [Ecstatic.Component.Configuration],
    commands: [Ecstatic.Command.Configuration],
    events: [Ecstatic.Event.Configuration],
    subscribers: [Ecstatic.Subscriber.Configuration],
  }}

  @collections [:systems, :families, :components, :commands, :events, :subscribers]
  @parents %{
    families: {:systems, :system},
    components: {:systems, :system},
    commands: {:components, :component},
    events: {:components, :component},
    subscribers: {:components, :component}
  }

  use TypedStruct
  use Domo, skip_defaults: true

  typedstruct do
    field :systems, list(Ecstatic.System.Configuration.t()), default: []
    field :families, list(Ecstatic.Family.Configuration.t()), default: []
    field :components, list(Ecstatic.Component.Configuration.t()), default: []
    field :commands, list(Ecstatic.Command.Configuration.t()), default: []
    field :events, list(Ecstatic.Event.Configuration.t()), default: []
    field :subscribers, list(Ecstatic.Subscriber.Configuration.t()), default: []
  end

  precond(t: &validate_invariants/1)

  defp validate_invariants(configuration) do
    unique_name_errors = @collections
                         |> Enum.map(fn type ->
                           collection = Map.get(configuration, type)
                           unique_names(collection, type)
                         end)
                         |> Enum.reject(&(:ok == &1))

    missing_parent_errors = @parents
                            |> Enum.flat_map(fn {collection, {parent_collection, attrib_name}} ->
                              collection = Map.get(configuration, collection)
                              parent_collection = Map.get(configuration, parent_collection)
                              find_parents(collection, parent_collection, attrib_name)
                            end)
                            |> Enum.reject(&(:ok == &1))

    case unique_name_errors ++ missing_parent_errors do
      [] ->
        :ok
      errors ->
        {:error, errors}
    end
  end

  @spec unpack(map()) :: {:ok, Ecstatic.Application.Configuration.t()} | {:error, String.t()}
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

  #
  # Utility functions
  #

  def map_to_named_list(nil) do
    []
  end

  def map_to_named_list(%{} = map) do
    Enum.map(map, fn {k, v} -> Map.put(v, "name", k) end)
  end

  defp unique_names(collection, type) do
    names = Enum.map(collection, &(&1.name))
    case Enum.uniq(names -- Enum.uniq(names)) do
      [] ->
        :ok
      duplicates ->
        "Duplicate names appear in the list of #{type}: #{duplicates}"
    end
  end

  defp find_parents(collection, parent_collection, attrib_name) do
    parent_names = Enum.map(parent_collection, &(&1.name))
    Enum.map(collection, &(find_parent(&1, parent_names, attrib_name)))
  end

  defp find_parent(thing, parent_names, attrib_name) do
    parent_name = Map.get(thing, attrib_name)
    if Enum.member?(parent_names, parent_name) do
      :ok
    else
      "Could not find parent #{attrib_name} (#{parent_name}) of #{thing.name}"
    end
  end
end
