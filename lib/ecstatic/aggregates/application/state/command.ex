defmodule Ecstatic.Aggregates.Application.State.Command do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        %Events.ComponentConfigured{} = component,
        commands
      ) do
    Enum.reduce_while(commands, {:ok, %State{}}, fn {k, v}, {:ok, state} ->
      with {:ok, name} <- Types.Name.long(system.name, :command, k),
           {:ok, schema} <- Types.Schema.new(Map.from_struct(v.schema)),
           {:ok, handler} <- Types.Handler.new(Map.from_struct(v.handler)),
           {:ok, command} <-
             Events.CommandConfigured.new(%{
               application_id: application.id,
               component_name: component.name,
               name: to_string(name),
               handler: handler,
               schema: schema
             }) do
        state = state |> State.merge(%State{commands: [command]})
        {:cont, {:ok, state}}
      else
        error ->
          {:halt, error}
      end
    end)
  end

  def validate(%State{} = state) do
    case state.commands
         |> Enum.map(fn c -> c.name end)
         |> (&(&1 -- Enum.uniq(&1))).()
         |> Enum.uniq() do
      [] ->
        :ok

      d ->
        {:error, "Application definition contains duplicate command names: #{Enum.join(d, ", ")}"}
    end
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.commands
      |> Enum.reject(fn n -> Enum.any?(existing.commands, fn e -> e.name == n.name end) end)

    remove =
      existing.commands
      |> Enum.reject(fn e -> Enum.any?(new.commands, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        Events.CommandRemoved.new!(%{application_id: e.application_id, name: e.name})
      end)

    update =
      new.commands
      |> Enum.filter(fn n -> Enum.any?(existing.commands, fn e -> e.name == n.name end) end)
      |> Enum.reject(fn n -> Enum.any?(existing.commands, fn e -> n == e end) end)

    schema_errors =
      update
      |> Enum.filter(fn n ->
        Enum.any?(existing.commands, fn e -> e.name == n.name && e.schema != n.schema end)
      end)
      |> Enum.map(fn n -> "Cannot change schema of command #{n.name}" end)

    case schema_errors do
      [] ->
        {:ok, add ++ remove ++ update}

      _ ->
        {:error, schema_errors}
    end
  end

  def update(%State{} = state, %Events.CommandConfigured{} = event) do
    %{state | commands: [event | state.commands |> Enum.reject(fn s -> s.name == event.name end)]}
  end

  def update(%State{} = state, %Events.CommandRemoved{} = event) do
    %{state | commands: state.commands |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
