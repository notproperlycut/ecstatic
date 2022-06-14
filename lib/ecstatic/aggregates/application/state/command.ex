defmodule Ecstatic.Aggregates.Application.State.Command do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types.Names

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        %Events.ComponentConfigured{} = _component,
        commands
      ) do
    Enum.reduce_while(commands, {:ok, %State{}}, fn {k, _v}, {:ok, state} ->
      with {:ok, name} <- Names.Command.new(%{system: system.name, command: k}),
           command <- %Events.CommandConfigured{
             application_id: application.id,
             name: to_string(name)
           } do
        state = state |> State.merge(%State{commands: [command]})
        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.commands
      |> Enum.reject(fn n -> Enum.any?(existing.commands, fn e -> e.name == n.name end) end)

    remove =
      existing.commands
      |> Enum.reject(fn e -> Enum.any?(new.commands, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        %Events.CommandRemoved{application_id: e.application_id, name: e.name}
      end)

    add ++ remove
  end

  def update(%State{} = state, %Events.CommandConfigured{} = event) do
    %{state | commands: [event | state.commands |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.CommandRemoved{} = event) do
    %{state | commands: state.commands |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
