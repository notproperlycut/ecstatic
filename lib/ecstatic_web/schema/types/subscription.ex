defmodule EcstaticWeb.Schema.Types.Subscription do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ecstatic.Applications

  object :subscription_spec do
    field :component_type, non_null(:component_type) do
      resolve(dataloader(Applications))
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
