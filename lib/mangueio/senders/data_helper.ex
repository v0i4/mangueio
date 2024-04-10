defmodule Mangueio.Senders.DataHelper do
  alias Mangueio.User.Alarms
  alias Telegex
  alias Mangueio.User.Alarm
  alias Mangueio.Interests.Result
  alias Mangueio.Interests.Interest
  alias Mangueio.Repo
  import Ecto.Query

  def send_telegram_notifications() do
    get_notificable_users()
    |> Enum.map(fn user -> prepare_data_for_notification(user.id) end)
  end

  defp get_notificable_users() do
    Repo.all(from a in Alarm, select: a, where: a.enabled == true)
  end

  defp prepare_data_for_notification(user_id) do
    alarm =
      user_id
      |> Alarms.get_alarm_by_user_id()

    # conteudo da notificacao
    results =
      alarm.user_id
      |> get_content()

    daily_msg_list =
      results
      |> Enum.map(fn {_alarm, result} ->
        """
        #{result.description}
        #{result.url}
        #{result.image}
        #{result.location}

        """
      end)

    # filtrar pelo cache

    cached =
      :ets.lookup(:notifications, user_id)
      |> List.last()
      |> elem(1)

    daily_msg_list
    |> Enum.map(fn msg ->
      if !Enum.member?(cached, msg) do
        IO.puts("NOVO ANUNCIO: #{msg}")
        Telegex.send_message(alarm.telegram_chat_id, msg)
      else
        IO.puts("ANUNCIO JA ENVIADO")
      end
    end)

    :ets.insert(:notifications, {user_id, daily_msg_list})
  end

  defp get_content(user_id) do
    query =
      from a in Alarm,
        join: i in Interest,
        on: i.user_id == a.user_id,
        join: r in Result,
        on: r.interest_id == i.id,
        where: a.user_id == ^user_id,
        select: {a, r}

    Repo.all(query)
  end
end
