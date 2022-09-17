defmodule Ecstatic.Commanded.Projectors.System do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.System",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.System

  project(%Events.System.Added{application: application, configuration: configuration}, _metadata, fn multi ->
    system = %System{
      application: application,
      name: configuration.name
    }

    Ecto.Multi.insert(multi, :system, system)
  end)

  project(%Events.System.Updated{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in System, where: c.application == ^application and c.name == ^configuration.name)

    # Nothing better to update, we'll use name (TODO: remove the handler if it's never needed)
    system = %{
      name: configuration.name
    }
    |> Keyword.new()

    Ecto.Multi.update_all(multi, :system, query, set: system)
  end)

  project(%Events.System.Removed{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in System, where: c.application == ^application and c.name == ^configuration.name)

    Ecto.Multi.delete_all(multi, :system, query)
  end)
end
