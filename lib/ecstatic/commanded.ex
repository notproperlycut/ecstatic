defmodule Ecstatic.Commanded do
  use Commanded.Application,
    otp_app: :ecstatic,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Ecstatic.EventStore
    ],
    pubsub: :local,
    registry: :local
end
