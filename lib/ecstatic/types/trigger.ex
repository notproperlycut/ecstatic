defmodule Ecstatic.Types.Trigger do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  use TypedStruct

  typedstruct do
    field :component, String.t(), enforce: true
  end

  precond(
    t: fn t ->
      Ecstatic.Types.Names.Component.valid_name(t.component)
    end
  )

  def empty() do
    __MODULE__.new!(%{component: "d.component.e"})
  end
end
