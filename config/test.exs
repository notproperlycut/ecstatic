import Config

config :ecstatic, Ecstatic.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore_test",
  hostname: "localhost",
  pool_size: 1

config :logger, level: :warn

config :commanded,
  assert_receive_event_timeout: 100,
  refute_receive_event_timeout: 100
