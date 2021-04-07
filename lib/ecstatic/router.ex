defmodule Ecstatic.Router do
  use Commanded.Commands.Router

  alias Ecstatic.Applications.Aggregates.Application

  alias Ecstatic.Applications.Commands.{
    CreateApplication,
    DestroyApplication,
    AddSystem,
    RemoveSystem
  }

  identify(Application, by: :id, prefix: "application-")

  dispatch(
    [
      CreateApplication,
      DestroyApplication,
      AddSystem,
      RemoveSystem
    ],
    to: Application
  )
end
