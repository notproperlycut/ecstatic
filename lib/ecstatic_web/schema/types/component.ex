defmodule EcstaticWeb.Schema.Types.ComponentType do
  use Absinthe.Schema.Notation

  alias EcstaticWeb.Resolvers

  object :component_type do
    field :name, non_null(:string)

    field :schema, non_null(:json)

    field :system, non_null(:system) do
      resolve(fn %{application_id: application_id, belongs_to_system: name}, _args, resolution ->
        Resolvers.Systems.get(%{application_id: application_id}, %{name: name}, resolution)
      end)
    end

    field :commands, list_of(:command) do
      resolve(&Resolvers.Commands.list_by_component_type/3)
    end

    field :events, list_of(:event) do
      resolve(&Resolvers.Events.list_by_component_type/3)
    end

    field :subscriptions, list_of(:subscription_spec) do
      resolve(&Resolvers.Subscriptions.list_by_component_type/3)
    end
  end

  input_object :component_type_definition_input do
    field :name, non_null(:string)
    field :schema, non_null(:json)
    field :commands, list_of(:command_definition_input)
    field :events, list_of(:event_definition_input)
    field :subscriptions, list_of(:subscription_definition_input)
  end
end
