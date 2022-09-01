defmodule Ecstatic.Aggregates.Application.State.System do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types.Name

  def configure(%Events.ApplicationConfigured{} = application, systems) do
    Enum.reduce_while(systems, {:ok, %State{}}, fn {k, v}, {:ok, state} ->
      with {:ok, name} <- Name.short(k),
           {:ok, system} <-
             Events.SystemConfigured.new(%{
               application: application.name,
               name: to_string(name)
             }),
           {:ok, families} <- State.Family.configure(application, system, v.families),
           {:ok, components} <- State.Component.configure(application, system, v.components) do
        state =
          state
          |> State.merge(%State{systems: [system]})
          |> State.merge(families)
          |> State.merge(components)

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
      new.systems
      |> Enum.reject(fn n -> Enum.any?(existing.systems, fn e -> e.name == n.name end) end)

    remove =
      existing.systems
      |> Enum.reject(fn e -> Enum.any?(new.systems, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        Events.SystemRemoved.new!(%{application: e.application, name: e.name})
      end)

    {:ok, add ++ remove}
  end

  def update(%State{} = state, %Events.SystemConfigured{} = event) do
    %{state | systems: [event | state.systems |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.SystemRemoved{} = event) do
    %{state | systems: state.systems |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
