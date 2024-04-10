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

    results
    |> Enum.map(fn {alarm, result} ->
      msg =
        """
        #{result.description}
        #{result.url}
        #{result.image}
        #{result.location}

        """

      Telegex.send_message(alarm.telegram_chat_id, msg)
    end)
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
