defmodule Ecstatic.Commanded.Types.Trigger do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  use TypedStruct

  typedstruct do
    field :component, String.t(), enforce: true
  end

  precond(
    t: fn t ->
      match?(%{class: :component}, Ecstatic.Commanded.Types.Name.classify(t.component))
    end
  )

  def empty() do
    __MODULE__.new!(%{component: "d.component.e"})
  end
end
