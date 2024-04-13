defmodule MangueioWeb.TelegramHookController do
  use MangueioWeb, :controller

  alias Telegex
  alias Mangueio.User.Alarms
  alias Mangueio.Accounts.User

  def index(conn, params) do
    chat_id = params["message"]["chat"]["id"]
    message = params["message"]["text"]

    # check if message is a valid email
    if String.match?(message, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/) do
      user = User.get_user_by_email(message) |> List.first()

      if is_nil(user) do
        Telegex.send_message(chat_id, "email invalido")

        conn
        |> put_status(200)
        |> json(%{ok: true})
      end

      case Alarms.get_alarm_by_user_id(user.id) do
        nil ->
          Alarms.create_alarm(%{
            user_id: user.id,
            telegram_chat_id: chat_id,
            enabled: true
          })

        _ ->
          Alarms.update_alarm(Alarms.get_alarm_by_user_id(user.id), %{
            enabled: true,
            telegram_chat_id: chat_id
          })
      end

      Telegex.send_message(5_140_539_663, "#{user.email} habilitou notificacoes!")
      Telegex.send_message(chat_id, "Notificacoes habilitadas!")

      Phoenix.PubSub.broadcast(
        Mangueio.PubSub,
        "telegram-alarm",
        Alarms.get_alarm_by_user_id(user.id)
      )
    else
      Telegex.send_message(chat_id, "email invalido")
    end

    conn
    |> put_status(200)
    |> json(%{ok: true})
  end
end
