defmodule EcstaticWeb.Schema do
  use Absinthe.Schema
  import_types(EcstaticWeb.Schema.EngineTypes)

  alias EcstaticWeb.Resolvers

  query do
    @desc "Get all engines"
    field :engines, list_of(:engine) do
      resolve(&Resolvers.Engines.list_engines/3)
    end

    field :engine, :engine do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Engines.get_engine/3)
    end
  end

  mutation do
    @desc "Create an engine"
    field :create_engine, type: :create_engine_payload do
      arg(:input, non_null(:create_engine_input))

      resolve(&Resolvers.Engines.create_engine/3)
    end

    @desc "Destroy an engine"
    field :destroy_engine, type: :destroy_engine_payload do
      arg(:input, non_null(:destroy_engine_input))

      resolve(&Resolvers.Engines.destroy_engine/3)
    end
  end
end
