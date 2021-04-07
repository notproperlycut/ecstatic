defmodule EcstaticWeb.Schema do
  use Absinthe.Schema

  import_types(EcstaticWeb.Schema.Types.Application)
  import_types(EcstaticWeb.Schema.Types.Custom.JSON)

  query do
    import_fields(:application_queries)
  end

  mutation do
    import_fields(:application_mutations)
    import_fields(:system_mutations)
  end
end
