defmodule Ecstatic.EventStore do
  use EventStore,
    otp_app: :ecstatic,
    serializer: Commanded.Serialization.JsonSerializer,
    schema: "ecstatic_commanded"

  def init(config) do
    config =
      config
      |> Keyword.merge(Application.fetch_env!(:ecstatic, :database))

    {:ok, config}
  end
end
