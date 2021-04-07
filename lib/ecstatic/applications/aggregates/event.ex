defmodule Ecstatic.Applications.Aggregates.Event do
  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Commands.{
    AddSystem,
    RemoveSystem
  }

  alias Ecstatic.Applications.Events.{
    EventAdded,
    EventRemoved,
    Handler
  }

  alias Ecstatic.Applications.Aggregates.Validators

  def add_system(%{id: application_id}, %AddSystem{} = add_system) do
    add_system.component_types
    |> Enum.flat_map(fn ct ->
      Enum.map(ct.events, fn e ->
        %EventAdded{
          application_id: application_id,
          belongs_to_component_type: ct.name,
          name: e.name,
          schema: e.schema,
          handler: Handler.new(e.handler)
        }
      end)
    end)
  end

  def remove_system(
        %{id: application_id, component_types: component_types, events: events},
        %RemoveSystem{name: name}
      ) do
    component_types
    |> Enum.filter(fn ct -> ct.belongs_to_system == name end)
    |> Enum.flat_map(fn ct ->
      Enum.filter(events, fn e -> e.belongs_to_component_type == ct.name end)
    end)
    |> Enum.map(fn e ->
      %EventRemoved{application_id: application_id, name: e.name}
    end)
  end

  def apply(application, %EventAdded{} = event) do
    %Application{application | events: [event | application.events]}
  end

  def apply(application, %EventRemoved{} = event) do
    events = Enum.reject(application.events, fn s -> s.name == event.name end)
    %Application{application | events: events}
  end

  def validate(%{events: events} = application) do
    [Validators.Names.validate_all_unique(events), Enum.map(events, &validate(&1, application))]
    |> Validators.collate_errors()
  end

  def validate(event, application) do
    [
      Validators.Names.validate_format(event, :event),
      Validators.Names.validate_share_system(event, :belongs_to_component_type),
      Validators.Entities.validate_relation(event, :belongs_to_component_type, application, :component_types),
      Validators.JsonSchema.validate(event),
      Validators.Handler.validate(event)
    ]
  end
end
