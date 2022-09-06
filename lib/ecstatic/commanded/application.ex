defmodule Ecstatic.Commanded.Application do
  use Commanded.Application,
    otp_app: :ecstatic,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Ecstatic.Commanded.EventStore
    ],
    pubsub: :local,
    registry: :local

  router(Ecstatic.Commanded.Router)
end
