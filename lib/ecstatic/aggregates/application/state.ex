defmodule Ecstatic.Aggregates.Application.State do
  use TypedStruct

  typedstruct do
    field :applications, any(), default: []
    field :families, any(), default: []
    field :systems, any(), default: []
    field :components, any(), default: []
    field :commands, any(), default: []
    field :events, any(), default: []
    field :subscribers, any(), default: []
  end

  alias Ecstatic.Aggregates.Application.State
  alias Ecstatic.Events

  def configure(%State{} = state, command) do
    with {:ok, new_state} <- State.Application.configure(command),
         :ok <- State.Application.validate(new_state),
         :ok <- State.System.validate(new_state),
         :ok <- State.Family.validate(new_state),
         :ok <- State.Component.validate(new_state),
         :ok <- State.Command.validate(new_state),
         :ok <- State.Event.validate(new_state),
         :ok <- State.Subscriber.validate(new_state),
         {:ok, applications} <- State.Application.add_remove(state, new_state),
         {:ok, systems} <- State.System.add_remove(state, new_state),
         {:ok, families} <- State.Family.add_remove(state, new_state),
         {:ok, components} <- State.Component.add_remove(state, new_state),
         {:ok, commands} <- State.Command.add_remove(state, new_state),
         {:ok, events} <- State.Event.add_remove(state, new_state),
         {:ok, subscribers} <- State.Subscriber.add_remove(state, new_state) do
      {:ok,
       applications ++ systems ++ families ++ components ++ commands ++ events ++ subscribers}
    end
  end

  def remove(%State{} = state) do
    with empty <- %State{},
         {:ok, applications} <- State.Application.add_remove(state, empty),
         {:ok, systems} <- State.System.add_remove(state, empty),
         {:ok, families} <- State.Family.add_remove(state, empty),
         {:ok, components} <- State.Component.add_remove(state, empty),
         {:ok, commands} <- State.Command.add_remove(state, empty),
         {:ok, events} <- State.Event.add_remove(state, empty),
         {:ok, subscribers} <- State.Subscriber.add_remove(state, empty) do
      {:ok,
       applications ++ systems ++ families ++ components ++ commands ++ events ++ subscribers}
    end
  end

  def merge(%State{} = state1, %State{} = state2) do
    %State{
      applications: state1.applications ++ state2.applications,
      systems: state1.systems ++ state2.systems,
      families: state1.families ++ state2.families,
      components: state1.components ++ state2.components,
      commands: state1.commands ++ state2.commands,
      events: state1.events ++ state2.events,
      subscribers: state1.subscribers ++ state2.subscribers
    }
  end

  def update(%State{} = state, %Events.ApplicationConfigured{} = event) do
    State.Application.update(state, event)
  end

  def update(%State{} = state, %Events.SystemConfigured{} = event) do
    State.System.update(state, event)
  end

  def update(%State{} = state, %Events.SystemRemoved{} = event) do
    State.System.update(state, event)
  end

  def update(%State{} = state, %Events.FamilyConfigured{} = event) do
    State.Family.update(state, event)
  end

  def update(%State{} = state, %Events.FamilyRemoved{} = event) do
    State.Family.update(state, event)
  end

  def update(%State{} = state, %Events.ComponentConfigured{} = event) do
    State.Component.update(state, event)
  end

  def update(%State{} = state, %Events.ComponentRemoved{} = event) do
    State.Component.update(state, event)
  end

  def update(%State{} = state, %Events.CommandConfigured{} = event) do
    State.Command.update(state, event)
  end

  def update(%State{} = state, %Events.CommandRemoved{} = event) do
    State.Command.update(state, event)
  end

  def update(%State{} = state, %Events.EventConfigured{} = event) do
    State.Event.update(state, event)
  end

  def update(%State{} = state, %Events.EventRemoved{} = event) do
    State.Event.update(state, event)
  end

  def update(%State{} = state, %Events.SubscriberConfigured{} = event) do
    State.Subscriber.update(state, event)
  end

  def update(%State{} = state, %Events.SubscriberRemoved{} = event) do
    State.Subscriber.update(state, event)
  end
end
