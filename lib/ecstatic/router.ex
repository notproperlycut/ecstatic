defmodule Ecstatic.Router do
  use Commanded.Commands.Router

  alias Ecstatic.{Commands, Aggregates}

  identify(Aggregates.Application, by: :id)
  identify(Aggregates.EntityComponent, by: :entity_component_id)

  dispatch([Commands.ConfigureApplication, Commands.RemoveApplication], to: Aggregates.Application)

  dispatch([Commands.ExecuteCommand], to: Aggregates.EntityComponent)
end
