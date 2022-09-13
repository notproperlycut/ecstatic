defmodule Ecstatic.Commanded.Projectors.Component do
  use Commanded.Projections.Ecto,
    application: Ecstatic.Commanded.Application,
    repo: Ecstatic.Commanded.Repo,
    name: "Projectors.Component",
    consistency: :strong

  alias Ecstatic.Commanded.Events
  alias Ecstatic.Commanded.Projections.Component

  project(%Events.Component.Added{application: application, configuration: configuration}, _metadata, fn multi ->
    component = %Component{
      application: application,
      system: configuration.system,
      name: configuration.name,
      schema: configuration.schema
    }

    Ecto.Multi.insert(multi, :component, component)
  end)

  project(%Events.Component.Updated{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Component,
        where: c.application == ^application and c.name == ^configuration.name
      )

    component = %Component{
      application: application,
      system: configuration.system,
      name: configuration.name,
      schema: configuration.schema
    }

    Ecto.Multi.update(multi, :component, query, set: component)
  end)

  project(%Events.Component.Removed{application: application, configuration: configuration}, _metadata, fn multi ->
    query =
      from(c in Component,
        where: c.application == ^application and c.name == ^configuration.name
      )

    Ecto.Multi.delete_all(multi, :component, query)
  end)
end
