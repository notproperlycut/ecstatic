defmodule Ecstatic.EventStore do
  use EventStore, otp_app: :ecstatic

  def init(_) do
    config =
      Application.fetch_env!(:ecstatic, :database)
      |> Keyword.put(:serializer, Commanded.Serialization.JsonSerializer)

    {:ok, config}
  end
end
