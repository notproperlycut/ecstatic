defmodule Ecstatic.Commanded.Projectors.EntityComponent do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.EntityComponent",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.EntityComponent

  project(%Events.EventInvocation.Succeeded{} = event, _metadata, fn multi ->
    ec = %EntityComponent{
      application: event.invocation.application,
      name: event.invocation.entity_component,
      value: event.entity_component_state
    }

    Ecto.Multi.insert(multi, :event, ec,
      on_conflict: [set: [value: ec.value]],
      conflict_target: [:application, :name]
    )
  end)
end
