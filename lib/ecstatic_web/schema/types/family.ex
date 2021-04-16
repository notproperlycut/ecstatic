defmodule EcstaticWeb.Schema.Types.Family do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Ecstatic.Applications

  object :family do
    field :name, non_null(:string)
    field :criteria, non_null(:string)

    field :system, non_null(:system) do
      resolve(dataloader(Applications))
    end
  end

  input_object :family_definition_input do
    field :name, non_null(:string)
    field :criteria, non_null(:string)
  end
end
