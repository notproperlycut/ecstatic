defmodule Ecstatic.Types.Names.Component do
  use Domo
  alias Ecstatic.Types.Names

  defstruct [
    system: "",
    component: "",
  ]

  @type t :: %__MODULE__{
    system: Names.t(),
    component: Names.t()
  }
end

defimpl String.Chars, for: Ecstatic.Types.Names.Component do
  def to_string(value), do: "#{value.system}.component.#{value.component}"
end
