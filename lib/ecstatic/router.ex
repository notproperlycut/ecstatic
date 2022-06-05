defmodule Ecstatic.Router do
  use Commanded.Commands.Router

  alias Ecstatic.{Commands, Aggregates}

  identify Aggregates.Application, by: :id
  dispatch [Commands.ConfigureApplication, Commands.RemoveApplication], to: Aggregates.Application
end
