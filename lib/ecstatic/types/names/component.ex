defmodule Ecstatic.Types.Names.Component do
  use Domo, skip_defaults: true
  alias Ecstatic.Types.Names

  use TypedStruct

  typedstruct do
    field :system, Names.t(), enforce: true
    field :component, Names.t(), enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)
end

defimpl String.Chars, for: Ecstatic.Types.Names.Component do
  def to_string(value), do: "#{value.system}.component.#{value.component}"
end
