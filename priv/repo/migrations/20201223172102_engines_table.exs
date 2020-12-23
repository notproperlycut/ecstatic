defmodule Ecstatic.Repo.Migrations.CreateEnginesTable do
	use Ecto.Migration

	def change do
		create table(:engines_engines, primary_key: false) do
			add :engine_id, :uuid, primary_key: true
			add :api_secret, :string

			timestamps()

		end
	end
end
