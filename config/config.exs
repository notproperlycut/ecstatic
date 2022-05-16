import Config

config :ecstatic, event_stores: [Ecstatic.EventStore]

import_config "#{config_env()}.exs"
