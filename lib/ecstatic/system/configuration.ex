defmodule Ecstatic.System.Configuration do
  @derive Nestru.Decoder
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
  end

  @spec unpack(map()) :: map()
  def unpack(system) do
    families = system["families"]
              |> Ecstatic.Application.Configuration.map_to_named_list()
              |> Enum.map(fn f -> Ecstatic.Family.Configuration.unpack(system, f) end)
    components = system["components"]
              |> Ecstatic.Application.Configuration.map_to_named_list()
              |> Enum.map(fn f -> Ecstatic.Component.Configuration.unpack(system, f) end)

    system
    |> Map.put("families", families)
    |> Map.put("components", components)
  end
end
