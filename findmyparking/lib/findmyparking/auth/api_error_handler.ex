defmodule Findmyparking.ApiErrorHandler do
  import Plug.Conn
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    IO.inspect reason
    body = Poison.encode!(%{error: to_string(type)})
    send_resp(conn, 401, body)
  end
end
