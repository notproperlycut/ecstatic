defmodule Ecstatic.Repo do
  use Ecto.Repo,
    otp_app: :ecstatic,
    adapter: Ecto.Adapters.Postgres
end
