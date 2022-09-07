defmodule Ecstatic.Family.Configuration do
  @derive {Nestru.Decoder, %{criteria: Ecstatic.Types.Criteria}}
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :system, String.t(), enforce: true
    field :criteria, Ecstatic.Types.Criteria.t(), enforce: true
  end

  @spec unpack(map(), map()) :: map()
  def unpack(%{"name" => system}, family) do
    {:ok, name} = Ecstatic.Types.Name.long(system, :family, family["name"])
    criteria = Ecstatic.Types.Criteria.unpack(family, family["criteria"])

    family
    |> Map.put("system", system)
    |> Map.put("name", name)
    |> Map.put("criteria", criteria)
  end
end
