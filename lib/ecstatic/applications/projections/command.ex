defmodule Ecstatic.Applications.Projections.Command do
  use Ecstatic.Applications.Projections.Schema

  alias Ecstatic.Applications.Projections.Handler

  schema "ecstatic_commands" do
    field(:name, :string)
    field(:application_id, :binary_id)
    field(:schema, :map)
    field(:belongs_to_component_type, :string)
    embeds_one(:handler, Handler)

    timestamps()
  end
end
