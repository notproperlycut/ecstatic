import Config

config :ecstatic, Ecstatic.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore",
  hostname: "localhost",
  pool_size: 10

