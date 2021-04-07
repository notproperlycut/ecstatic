defmodule EcstaticWeb.Schema.Types.Family do
  use Absinthe.Schema.Notation

  alias EcstaticWeb.Resolvers

  object :family do
    field :name, non_null(:string)
    field :criteria, non_null(:string)

    field :system, non_null(:system) do
      resolve(fn %{application_id: application_id, belongs_to_system: name}, _args, resolution ->
        Resolvers.Systems.get(%{application_id: application_id}, %{name: name}, resolution)
      end)
    end
  end

  input_object :family_definition_input do
    field :name, non_null(:string)
    field :criteria, non_null(:string)
  end
end
