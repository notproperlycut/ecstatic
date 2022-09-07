defmodule Ecstatic.Types.Criteria do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct

  typedstruct do
    field :has, String.t(), enforce: true
  end

  @spec unpack(map(), map()) :: map()
  def unpack(%{"name" => parent}, criteria) do
    {:ok, has} = Ecstatic.Types.Name.long(parent, :component, criteria["has"])

    criteria
    |> Map.put("has", has)
  end
end
