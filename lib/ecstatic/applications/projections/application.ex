defmodule Ecstatic.Applications.Projections.Application do
  use Ecstatic.Applications.Projections.Schema

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "ecstatic_applications" do
    field(:api_secret, :string)

    timestamps()
  end
end
