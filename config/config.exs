# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ecstatic,
  ecto_repos: [Ecstatic.Repo],
  event_stores: [Ecstatic.EventStore]

# Configures the endpoint
config :ecstatic, EcstaticWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "37X3g9F2qZUDwPCz11wuVDPVCcFk9cXHMS2zqDdesl6FXzPnCKBo8gGrBgHmenxD",
  render_errors: [view: EcstaticWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Ecstatic.PubSub,
  live_view: [signing_salt: "dBWb1vl2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commanded_ecto_projections,
  repo: Ecstatic.Repo

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
