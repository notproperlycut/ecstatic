defmodule Ecstatic.Aggregates.Application.State.Component do
  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events
  alias Ecstatic.Types.Names

  def configure(
        %Events.ApplicationConfigured{} = application,
        %Events.SystemConfigured{} = system,
        components
      ) do
    Enum.reduce(components, %State{}, fn {k, v}, state ->
      {:ok, name} = Names.Component.new(%{system: "#{system.name}", component: "#{k}"})
      component = %Events.ComponentConfigured{
        application_id: application.id,
        name: to_string(name)
      }

      commands = State.Command.configure(application, system, component, v.commands)
      events = State.Event.configure(application, system, component, v.events)
      subscribers = State.Subscriber.configure(application, system, component, v.subscribers)

      state
      |> State.merge(%State{components: [component]})
      |> State.merge(commands)
      |> State.merge(events)
      |> State.merge(subscribers)
    end)
  end

  def add_remove(%State{} = existing, %State{} = new) do
    add =
      new.components
      |> Enum.reject(fn n -> Enum.any?(existing.components, fn e -> e.name == n.name end) end)

    remove =
      existing.components
      |> Enum.reject(fn e -> Enum.any?(new.components, fn n -> n.name == e.name end) end)
      |> Enum.map(fn e ->
        %Events.ComponentRemoved{application_id: e.application_id, name: e.name}
      end)

    add ++ remove
  end

  def update(%State{} = state, %Events.ComponentConfigured{} = event) do
    %{
      state
      | components: [event | state.components |> Enum.reject(fn s -> s.name == event.name end)]
    }
  end

  def update(%State{} = state, %Events.ComponentRemoved{} = event) do
    %{state | components: state.components |> Enum.reject(fn s -> s.name == event.name end)}
  end
end
