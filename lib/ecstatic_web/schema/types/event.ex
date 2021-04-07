defmodule EcstaticWeb.Schema.Types.Event do
  use Absinthe.Schema.Notation

  alias EcstaticWeb.Resolvers

  object :event do
    field :name, non_null(:string)
    field :schema, non_null(:json)

    field :component_type, non_null(:component_type) do
      resolve(fn %{application_id: application_id, belongs_to_component_type: name}, _args, resolution ->
        Resolvers.ComponentTypes.get(%{application_id: application_id}, %{name: name}, resolution)
      end)
    end

    field :handler, non_null(:handler)
  end

  input_object :event_definition_input do
    field :name, non_null(:string)
    field :schema, non_null(:json)
    field :handler, non_null(:handler_definition_input)
  end
end
