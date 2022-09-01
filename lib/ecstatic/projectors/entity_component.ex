defmodule Ecstatic.Projectors.EntityComponent do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded,
    repo: Ecstatic.Repo,
    name: "Projectors.EntityComponent",
    consistency: :strong

  alias Ecstatic.Events
  alias Ecstatic.Projections.EntityComponent

  project(%Events.EventInvocation.Succeeded{} = event, _metadata, fn multi ->
    ec = %EntityComponent{
      application: event.invocation.application,
      name:
        "#{Ecstatic.Types.EntityComponentId.new!(event.invocation.entity_component)}",
      value: event.entity_component_state
    }

    Ecto.Multi.insert(multi, :event, ec,
      on_conflict: [set: [value: ec.value]],
      conflict_target: [:application, :name]
    )
  end)
end
