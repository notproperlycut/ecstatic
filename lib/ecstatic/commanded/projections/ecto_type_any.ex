defmodule Ecstatic.Commanded.Projections.EctoTypeAny do
  alias Ecto.Type
  @behaviour Type

  @impl Type
  def type, do: :any

  @impl Type
  def cast(value), do: Type.cast(:any, value)

  @impl Type
  def load(value), do: Type.load(:any, value)

  @impl Type
  def dump(value), do: Type.dump(:any, value)

  @impl Type
  def equal?(value1, value2), do: Type.equal?(:any, value1, value2)

  @impl Type
  def embed_as(format), do: Type.embed_as(:any, format)
end
