defmodule EcstaticWeb.Schema.Types.ComponentType do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ecstatic.Applications

  object :component_type do
    field :name, non_null(:string)

    field :schema, non_null(:json)

    field :system, non_null(:system) do
      resolve(dataloader(Applications))
    end

    field :commands, list_of(:command) do
      resolve(dataloader(Applications))
    end

    field :events, list_of(:event) do
      resolve(dataloader(Applications))
    end

    field :subscriptions, list_of(:subscription_spec) do
      resolve(dataloader(Applications))
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
