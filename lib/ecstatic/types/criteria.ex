defmodule Ecstatic.Types.Criteria do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  use TypedStruct

  typedstruct do
    field :has, String.t(), enforce: true
  end

  precond(
    t: fn t ->
      Ecstatic.Types.Names.Component.valid_name(t.has)
    end
  )

  def empty() do
    __MODULE__.new!(%{has: "d.component.e"})
  end
end
