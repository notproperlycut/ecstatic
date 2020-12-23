defmodule EcstaticWeb.Schema.EngineTypes do
  use Absinthe.Schema.Notation

  object :engine do
    field :engine_id, :id
  end

  input_object :create_engine_input do
    field :api_secret, non_null(:string)
  end

  object :create_engine_payload do
    field :engine, non_null(:engine)
  end

  input_object :destroy_engine_input do
    field :engine_id, non_null(:id)
  end

  object :destroy_engine_payload do
    field :engine_id, non_null(:id)
  end
end
