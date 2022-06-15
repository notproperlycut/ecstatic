defmodule Ecstatic.Aggregates.Application.State.Family do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types.Names

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        families
      ) do
    Enum.reduce_while(families, {:ok, %State{}}, fn {k, _v}, {:ok, state} ->
      with {:ok, name} <- Names.Family.new(%{system: system.name, family: k}),
           {:ok, family} <-
             Events.FamilyConfigured.new(%{
               application_id: application.id,
               name: to_string(name)
             }) do
        state = state |> State.merge(%State{families: [family]})
        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.families
      |> Enum.reject(fn n -> Enum.any?(existing.families, fn e -> e.name == n.name end) end)

    remove =
      existing.families
      |> Enum.reject(fn e -> Enum.any?(new.families, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        Events.FamilyRemoved.new!(%{application_id: e.application_id, name: e.name})
      end)

    add ++ remove
  end

  def update(%State{} = state, %Events.FamilyConfigured{} = event) do
    %{state | families: [event | state.families |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.FamilyRemoved{} = event) do
    %{state | families: state.families |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
