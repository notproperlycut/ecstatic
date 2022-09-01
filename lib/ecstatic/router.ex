defmodule Ecstatic.Router do
  use Commanded.Commands.Router

  alias Ecstatic.{Commands, Aggregates}

  identify(Aggregates.Application, by: :name)
  identify(Aggregates.EntityComponent, by: :entity_component)

  dispatch([Commands.ConfigureApplication, Commands.RemoveApplication], to: Aggregates.Application)

  dispatch(
    [
      Commands.CommandInvocation.Request,
      Commands.CommandInvocation.Succeed,
      Commands.CommandInvocation.Fail
    ],
    to: Aggregates.EntityComponent
  )

  dispatch([Commands.EventInvocation.Succeed, Commands.EventInvocation.Fail],
    to: Aggregates.EntityComponent
  )
end
