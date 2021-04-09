defmodule EcstaticWeb.Schema.Types.Subscription do
  use Absinthe.Schema.Notation

  alias EcstaticWeb.Resolvers

  object :subscription_spec do
    field :component_type, non_null(:component_type) do
      resolve(fn %{application_id: application_id, belongs_to_component_type: name},
                 _args,
                 resolution ->
        Resolvers.ComponentTypes.get(%{application_id: application_id}, %{name: name}, resolution)
      end)
    end

    field :name, non_null(:string)
    field :trigger, non_null(:string)
    field :payload, non_null(:string)
    field :handler, non_null(:handler)
  end

  input_object :subscription_definition_input do
    field :name, non_null(:string)
    field :trigger, non_null(:string)
    field :payload, non_null(:string)
    field :handler, non_null(:handler_definition_input)
  end
end
