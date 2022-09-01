defmodule Ecstatic.Projections.System do
  use Ecto.Schema

  schema "systems" do
    field(:application, :string)
    field(:name, :string)
  end
end
