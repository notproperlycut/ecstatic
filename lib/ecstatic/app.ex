defmodule Ecstatic.App do
	use Commanded.Application,
		otp_app: :my_app,
		event_store: [
			adapter: Commanded.EventStore.Adapters.EventStore,
			event_store: Ecstatic.EventStore
		]

	router Ecstatic.Router
end
