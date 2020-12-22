defmodule EcstaticWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :ecstatic

  plug Plug.RequestId
  plug Plug.Logger
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug CORSPlug

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug EcstaticWeb.Context

  plug Absinthe.Plug,
    schema: EcstaticWeb.Schema
end
