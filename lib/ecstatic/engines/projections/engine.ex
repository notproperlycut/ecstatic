defmodule Ecstatic.Engines.Projections.Engine do
  use Ecto.Schema

  @primary_key {:engine_id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "engines_engines" do
    field(:api_secret, :string)

    timestamps()
  end
end
