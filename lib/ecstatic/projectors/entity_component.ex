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
      application_id: event.invocation.application_id,
      entity_component_id:
        "#{Ecstatic.Types.EntityComponentId.new!(event.invocation.entity_component_id)}",
      # value: %{state: event.entity_component_state},
      value: event.entity_component_state
    }

    Ecto.Multi.insert(multi, :event, ec,
      on_conflict: [set: [value: ec.value]],
      conflict_target: [:application_id, :entity_component_id]
    )
  end)
end
