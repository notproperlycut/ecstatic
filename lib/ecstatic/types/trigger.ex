defmodule Ecstatic.Types.Trigger do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct

  typedstruct do
    field :component, String.t(), enforce: true
  end

  @spec unpack(map(), map()) :: map()
  def unpack(%{"name" => parent}, trigger) do
    {:ok, component} = Ecstatic.Types.Name.long(parent, :component, trigger["component"])

    trigger
    |> Map.put("component", component)
  end
end
