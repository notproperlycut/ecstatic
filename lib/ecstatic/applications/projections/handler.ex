defmodule Ecstatic.Applications.Projections.Handler do
  use Ecstatic.Applications.Projections.Schema

  @primary_key false

  embedded_schema do
    field(:url, :string)
  end
end
