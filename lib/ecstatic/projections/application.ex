defmodule Ecstatic.Projections.Application do
  use Ecto.Schema

  schema "applications" do
    field :name, :string
  end
end
