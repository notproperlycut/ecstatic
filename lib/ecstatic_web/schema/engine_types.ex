defmodule EcstaticWeb.Schema.EngineTypes do
  use Absinthe.Schema.Notation

  object :engine do
    field :engine_id, :id
  end
end
