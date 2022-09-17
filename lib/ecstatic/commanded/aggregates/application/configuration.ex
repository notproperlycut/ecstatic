defmodule Ecstatic.Commanded.Aggregates.Application.Configuration do
  @collection_module_mapping %{
    systems: Ecstatic.Commanded.Events.System,
    families: Ecstatic.Commanded.Events.Family,
    components: Ecstatic.Commanded.Events.Component,
    commands: Ecstatic.Commanded.Events.Command,
    events: Ecstatic.Commanded.Events.Event,
    subscribers: Ecstatic.Commanded.Events.Subscriber,
  }

  @spec add(String.t(), Ecstatic.Application.Configuration.t()) :: {:ok, list()} | {:error, String.t()}
  def add(name, %Ecstatic.Application.Configuration{} = configuration) do
    update(name, %Ecstatic.Application.Configuration{}, configuration)
  end

  @spec remove(String.t(), Ecstatic.Application.Configuration.t()) :: {:ok, list()} | {:error, String.t()}
  def remove(name, configuration) do
    update(name, configuration, %Ecstatic.Application.Configuration{})
  end

  @spec update(String.t(), Ecstatic.Application.Configuration.t(), Ecstatic.Application.Configuration.t()) :: {:ok, list()} | {:error, String.t()}
  def update(name, old, new) do
    add_events = Enum.flat_map(@collection_module_mapping, fn {collection, module} ->
      old_collection = Map.from_struct(old)[collection]
      new_collection = Map.from_struct(new)[collection]

      add_events(old_collection, new_collection)
      |> Enum.map(fn x -> pack_event(Module.concat(module, Added), name, x) end)
    end)

    remove_events = Enum.flat_map(@collection_module_mapping, fn {collection, module} ->
      old_collection = Map.from_struct(old)[collection]
      new_collection = Map.from_struct(new)[collection]

      remove_events(old_collection, new_collection)
      |> Enum.map(fn x -> pack_event(Module.concat(module, Removed), name, x) end)
    end)

    update_events = Enum.flat_map(@collection_module_mapping, fn {collection, module} ->
      old_collection = Map.from_struct(old)[collection]
      new_collection = Map.from_struct(new)[collection]

      update_event_pairs(old_collection, new_collection)
      |> Enum.map(fn {_o, n} -> n end)
      |> Enum.map(fn x -> pack_event(Module.concat(module, Updated), name, x) end)
    end)

    events = add_events ++ remove_events ++ update_events
    {:ok, events}
  end

  defp pack_event(module, application, configuration) do
    struct!(module, application: application, configuration: configuration)
  end

  defp add_events(old, new) do
    Enum.reject(new, fn n -> Enum.any?(old, fn o -> o.name == n.name end) end)
  end

  defp remove_events(old, new) do
    Enum.reject(old, fn o -> Enum.any?(new, fn n -> n.name == o.name end) end)
  end

  defp update_event_pairs(old, new) do
    Enum.map(new, fn n -> {Enum.find(old, fn o -> o.name == n.name end), n} end)
    |> Enum.filter(fn {o, _n} -> o end)
    |> Enum.filter(fn {_o, n} -> n end)
    |> Enum.reject(fn {o, n} -> o == n end)
  end
end
