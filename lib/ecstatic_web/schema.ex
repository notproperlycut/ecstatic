defmodule EcstaticWeb.Schema do
	use Absinthe.Schema
	import_types EcstaticWeb.Schema.EngineTypes

	alias EcstaticWeb.Resolvers

	query do

		@desc "Get all engines"
		field :engines, list_of(:engine) do
			resolve &Resolvers.Engines.list_engines/3
		end

	end

	mutation do

		@desc "Create an engine"
		field :create_engine, type: :id do
			arg :api_secret, non_null(:string)

			resolve &Resolvers.Engines.create_engine/3
		end

		@desc "Destroy an engine"
		field :destroy_engine, type: :id do
			arg :engine_id, non_null(:id)

			resolve &Resolvers.Engines.destroy_engine/3
		end
	end

end
