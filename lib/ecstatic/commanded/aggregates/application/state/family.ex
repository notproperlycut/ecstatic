defmodule Ecstatic.Commanded.Aggregates.Application.State.Family do
  alias Ecstatic.Commanded.Aggregates.Application.State
  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Types

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        families
      ) do
    Enum.reduce_while(families, {:ok, %State{}}, fn {k, v}, {:ok, state} ->
      with {:ok, name} <- Types.Name.long(system.name, :family, k),
           {:ok, criteria} <- Types.Criteria.new(Map.from_struct(v.criteria)),
           {:ok, family} <-
             Events.FamilyConfigured.new(%{
               application: application.name,
               name: to_string(name),
               criteria: criteria
             }) do
        state = state |> State.merge(%State{families: [family]})
        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def validate(%State{} = _state) do
    :ok
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.families
      |> Enum.reject(fn n -> Enum.any?(existing.families, fn e -> e.name == n.name end) end)

    remove =
      existing.families
      |> Enum.reject(fn e -> Enum.any?(new.families, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        Events.FamilyRemoved.new!(%{application: e.application, name: e.name})
      end)

    update =
      new.families
      |> Enum.filter(fn n -> Enum.any?(existing.families, fn e -> e.name == n.name end) end)
      |> Enum.reject(fn n -> Enum.any?(existing.families, fn e -> n == e end) end)

    criteria_errors =
      update
      |> Enum.filter(fn n ->
        Enum.any?(existing.families, fn e -> e.name == n.name && e.criteria != n.criteria end)
      end)
      |> Enum.map(fn n -> "Cannot change criteria of family #{n.name}" end)

    case criteria_errors do
      [] ->
        {:ok, add ++ remove ++ update}

      _ ->
        {:error, criteria_errors}
    end
  end

  def update(%State{} = state, %Events.FamilyConfigured{} = event) do
    %{state | families: [event | state.families |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.FamilyRemoved{} = event) do
    %{state | families: state.families |> Enum.reject(fn s -> s.name == event.name end)}
  end
end