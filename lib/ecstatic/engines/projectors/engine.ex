defmodule Ecstatic.Engines.Projectors.Engine do
  use Commanded.Projections.Ecto,
    application: Ecstatic.App,
    name: "Engines.Projectors.Engine",
    consistency: :strong

  alias Ecstatic.Engines.Events.{
    EngineCreated,
    EngineDestroyed
  }

  alias Ecstatic.Engines.Projections.Engine

  project(%EngineCreated{} = engine, fn multi ->
    Ecto.Multi.insert(multi, :create, %Engine{
      engine_id: engine.engine_id,
      api_secret: engine.api_secret
    })
  end)

  project(%EngineDestroyed{engine_id: engine_id}, fn multi ->
    # TODO: presumably faster to delete one row
    queryable = from(e in Engine, where: e.engine_id == ^engine_id)
    Ecto.Multi.delete_all(multi, :destroy, queryable)
  end)
end
