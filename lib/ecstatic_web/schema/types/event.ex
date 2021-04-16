defmodule EcstaticWeb.Schema.Types.Event do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ecstatic.Applications

  object :event do
    field :name, non_null(:string)
    field :schema, non_null(:json)

    field :component_type, non_null(:component_type) do
      resolve(dataloader(Applications))
    end

    field :handler, non_null(:handler)
  end

  input_object :event_definition_input do
    field :name, non_null(:string)
    field :schema, non_null(:json)
    field :handler, non_null(:handler_definition_input)
  end
end
