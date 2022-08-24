defmodule Ecstatic.Projections.System do
  use Ecto.Schema

  schema "systems" do
    field(:application_id, :string)
    field(:name, :string)
  end
end
