defmodule EcstaticWeb.Schema.Types.Application do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias EcstaticWeb.Resolvers
  alias Ecstatic.Applications
  import_types(EcstaticWeb.Schema.Types.Command)
  import_types(EcstaticWeb.Schema.Types.ComponentType)
  import_types(EcstaticWeb.Schema.Types.Event)
  import_types(EcstaticWeb.Schema.Types.Family)
  import_types(EcstaticWeb.Schema.Types.Handler)
  import_types(EcstaticWeb.Schema.Types.Subscription)
  import_types(EcstaticWeb.Schema.Types.System)

  object :application do
    field :id, non_null(:id)

    field :systems, list_of(:system) do
      resolve dataloader(Applications)
    end

    field :families, list_of(non_null(:family)) do
      resolve dataloader(Applications)
    end

    field :component_types, list_of(non_null(:component_type)) do
      resolve dataloader(Applications)
    end

    field :commands, list_of(non_null(:command)) do
      resolve dataloader(Applications)
    end

    field :events, list_of(non_null(:event)) do
      resolve dataloader(Applications)
    end

    field :subscriptions, list_of(non_null(:subscription_spec)) do
      resolve dataloader(Applications)
    end
  end

  input_object :create_application_input do
    field :api_secret, non_null(:string)
  end

  object :create_application_payload do
    field :application, non_null(:application)
  end

  input_object :destroy_application_input do
    field :id, non_null(:id)
  end

  object :destroy_application_payload do
    field :id, non_null(:id)
  end

  object :application_queries do
    @desc "Get all applications"
    field :applications, list_of(:application) do
      resolve(&Resolvers.Applications.list/3)
    end

    field :application, :application do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Applications.get/3)
    end
  end

  object :application_mutations do
    @desc "Create an application"
    field :create_application, type: :create_application_payload do
      arg(:input, non_null(:create_application_input))
      resolve(&Resolvers.Applications.create/3)
    end

    @desc "Destroy an application"
    field :destroy_application, type: :destroy_application_payload do
      arg(:input, non_null(:destroy_application_input))
      resolve(&Resolvers.Applications.destroy/3)
    end
  end
end
