defmodule Ecstatic.Commanded.Repo do
  use Ecto.Repo,
    otp_app: :ecstatic,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    {:ok, Keyword.merge(config, Application.fetch_env!(:ecstatic, :database))}
  end
end
