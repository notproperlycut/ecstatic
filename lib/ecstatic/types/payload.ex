defmodule Ecstatic.Types.Payload do
  @derive Jason.Encoder
  @derive Nestru.Decoder

  use TypedStruct
  use Domo, skip_defaults: true

  typedstruct do
    field :json, String.t(), enforce: true
  end

  precond(
    t: fn s ->
      try do
        Jason.decode!(s.json)
        :ok
      rescue
        e in Jason.DecodeError ->
          {:error, "invalid json payload: '#{e.message}'"}
      end
    end
  )
end
