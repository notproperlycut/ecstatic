defmodule Ecstatic.Applications.Aggregates.Event do
  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Events.{
    EventAdded,
    EventRemoved,
    Handler
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add(application, system, component_type, add_events) do
    add_events
    |> Enum.map(&add_event(application, system, component_type, &1))
    |> List.flatten()
  end

  defp add_event(application, system, component_type, add_event) do
    %EventAdded{
      id: UUID.uuid4(),
      name: add_event.name,
      schema: add_event.schema,
      handler: Handler.new(add_event.handler),
      application_id: application.id,
      system_id: system.id,
      component_type_id: component_type.id
    }
  end

  def remove(application, component_type) do
    application.events
    |> Enum.filter(&(&1.component_type_id == component_type.id))
    |> Enum.map(&remove_event(&1))
    |> List.flatten()
  end

  defp remove_event(event) do
    %EventRemoved{id: event.id}
  end

  def apply(application, %EventAdded{} = event) do
    %Application{application | events: [event | application.events]}
  end

  def apply(application, %EventRemoved{} = event) do
    events = Enum.reject(application.events, fn s -> s.id == event.id end)
    %Application{application | events: events}
  end

  def apply(%Application{} = application, _event) do
    application
  end

  def validate(application) do
    [
      Validators.Names.validate_all_unique(application.events),
      Enum.map(application.events, &validate_event(&1, application))
    ]
    |> Validators.collate_errors()
  end

  def validate_event(event, application) do
    [
      Validators.Names.validate_format(event, :event),
      Validators.Names.validate_share_system(
        event,
        :component_type_id,
        application,
        :component_types
      ),
      Validators.JsonSchema.validate(event),
      Validators.Handler.validate(event)
    ]
  end
end
