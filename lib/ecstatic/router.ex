defmodule Ecstatic.Router do
  use Commanded.Commands.Router

	alias Ecstatic.Engines.Aggregates.Engine
	alias Ecstatic.Engines.Commands.{CreateEngine, DestroyEngine}

	alias Ecstatic.Support.Middleware.Validate
	middleware(Validate)

	identify(Engine, by: :engine_id, prefix: "engine-")

	dispatch(
		[
			CreateEngine,
			DestroyEngine
		],
		to: Engine
	)
end
