defmodule Ecstatic.Commanded.Types.Payload do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  use TypedStruct

  typedstruct do
    field :json, String.t(), enforce: true
  end

  precond(
    t: fn s ->
      try do
        Jason.decode!(s.json)
        :ok
      rescue
        Jason.DecodeError ->
          {:error, "invalid json payload '#{String.slice(s.json, 0..20)}'"}
      end
    end
  )

  def empty() do
    __MODULE__.new!(%{json: Jason.encode!(%{})})
  end
end
