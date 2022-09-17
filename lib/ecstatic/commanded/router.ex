defmodule Ecstatic.Commanded.Router do
  use Commanded.Commands.Router

  alias Ecstatic.Commanded.{Commands, Aggregates}

  identify(Aggregates.Application, by: :name)
  identify(Aggregates.EntityComponent, by: :entity_component)

  dispatch([Commands.Application.Configure, Commands.Application.Remove], to: Aggregates.Application)

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
