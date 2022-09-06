defmodule Ecstatic.Commanded.Types.Handler do
  @derive Jason.Encoder
  use Domo, skip_defaults: true

  use TypedStruct

  @type handler :: list()
  typedstruct do
    field :mfa, handler, enforce: true
  end

  # TODO: workaround dialyzer warning from domo __precond__ generator
  precond(t: fn _ -> :ok end)

  def empty() do
    __MODULE__.new!(%{mfa: [__MODULE__, :dummy, 1]})
  end

  def dummy(_) do
    {:ok, []}
  end
end

defimpl Commanded.Serialization.JsonDecoder, for: Ecstatic.Commanded.Types.Handler do
  def decode(%Ecstatic.Commanded.Types.Handler{mfa: mfa} = event) do
    new_mfa =
      Enum.map(mfa, fn
        s when is_binary(s) -> String.to_atom(s)
        o -> o
      end)

    %Ecstatic.Commanded.Types.Handler{event | mfa: new_mfa}
  end
end
