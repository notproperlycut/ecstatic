defmodule Ecstatic.Projections.Application do
  use Ecto.Schema

  @primary_key false
  schema "applications" do
    field :id, :string, primary_key: true
  end
end
