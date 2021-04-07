defmodule EcstaticWeb.Schema.Types.System do
  use Absinthe.Schema.Notation

  alias EcstaticWeb.Resolvers

  object :system do
    field :name, non_null(:string)

    field :application, non_null(:application) do
      resolve(&Resolvers.Applications.get/3)
    end

    field :commands, list_of(non_null(:command)) do
      resolve(&Resolvers.Commands.list_by_system/3)
    end

    field :component_types, list_of(non_null(:component_type)) do
      resolve(&Resolvers.ComponentTypes.list_by_system/3)
    end

    field :events, list_of(non_null(:event)) do
      resolve(&Resolvers.Events.list_by_system/3)
    end

    field :families, list_of(non_null(:family)) do
      resolve(&Resolvers.Families.list_by_system/3)
    end

    field :subscriptions, list_of(non_null(:subscription_spec)) do
      resolve(&Resolvers.Subscriptions.list_by_system/3)
    end
  end

  input_object :system_definition_input do
    field :application_id, non_null(:id)
    field :name, non_null(:string)
    field :component_types, list_of(:component_type_definition_input)
    field :families, list_of(:family_definition_input)
  end

  object :add_system_payload do
    field :application, non_null(:application)
  end

  input_object :remove_system_input do
    field :application_id, non_null(:id)
    field :name, non_null(:string)
  end

  object :remove_system_payload do
    field :application, non_null(:application)
  end

  object :system_mutations do
    @desc "Add an system"
    field :add_system, type: :add_system_payload do
      arg(:input, non_null(:system_definition_input))
      resolve(&Resolvers.Systems.add/3)
    end

    @desc "Remove an system"
    field :remove_system, type: :remove_system_payload do
      arg(:input, non_null(:remove_system_input))
      resolve(&Resolvers.Systems.remove/3)
    end
  end
end
