defmodule Mangueio.TelegramHookPlug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("json")
    |> send_resp(200, "Hello World!\n")
  end
end
