defmodule Ecstatic.Types.Criteria do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct
  use Domo, skip_defaults: true

  typedstruct do
    field :has, String.t(), enforce: true
  end

  precond(
    t: fn t ->
      match?(%{class: :component}, Ecstatic.Types.Name.classify(t.has))
    end
  )

  @spec unpack(map(), map()) :: map()
  def unpack(%{"name" => parent}, criteria) do
    {:ok, has} = Ecstatic.Types.Name.long(parent, :component, criteria["has"])

    criteria
    |> Map.put("has", has)
  end
end
