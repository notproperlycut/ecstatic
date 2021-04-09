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

	def dataloader() do
		alias Ecstatic.Applications

		Dataloader.new
		|> Dataloader.add_source(Applications, Applications.data())
	end

	def context(ctx) do
		Map.put(ctx, :loader, dataloader())
	end

	def plugins do
		[Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults]
	end
end
