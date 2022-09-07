defmodule Ecstatic.Command.Configuration do
  @derive {Nestru.Decoder, %{schema: Ecstatic.Types.Schema, handler: Ecstatic.Types.Handler}}
  use TypedStruct

  typedstruct do
    field :component, String.t(), enforce: true
    field :name, String.t(), enforce: true
    field :schema, Ecstatic.Types.Schema.t(), enforce: true
    field :handler, Ecstatic.Types.Handler.t(), enforce: true
  end

  @spec unpack(map(), map()) :: map()
  def unpack(%{"name" => component}, command) do
    {:ok, name} = Ecstatic.Types.Name.long(component, :command, command["name"])

    command
    |> Map.put("component", component)
    |> Map.put("name", name)
  end
end
