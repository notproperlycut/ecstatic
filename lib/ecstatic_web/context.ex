defmodule EcstaticWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    authorize(conn)
  end

  defp authorize(conn) do
    admin_password = admin_password()
    with {"admin", ^admin_password} <- Plug.BasicAuth.parse_basic_auth(conn) do
      Absinthe.Plug.assign_context(conn, scope: :admin)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end

  defp admin_password() do
    Application.fetch_env!(:ecstatic, __MODULE__) |> Keyword.fetch!(:admin_password)
  end

end
