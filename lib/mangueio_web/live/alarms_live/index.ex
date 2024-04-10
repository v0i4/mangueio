defmodule MangueioWeb.AlarmsLive.Index do
  use MangueioWeb, :live_view

  alias Mangueio.User.Alarms
  alias Telegex

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Mangueio.PubSub, "telegram-alarm")
    end

    user = socket.assigns.current_user

    alarm = Alarms.get_alarm_by_user_id(user.id) |> IO.inspect()
    socket = assign(socket, :alarm, alarm)

    socket =
      socket
      |> assign(:current_user, user)

    {:ok, socket}
  end

  @impl true
  def handle_info({ref, result}, socket) do
    Process.demonitor(ref, [:flush])
    IO.inspect(result)

    {:noreply, socket}
  end

  @impl true
  def handle_info(new_alarm, socket) do
    socket = assign(socket, :alarm, new_alarm)
    {:noreply, socket |> put_flash(:info, "Notificacoes habilitadas!")}
  end

  @impl true
  def handle_event("disable-alarms", _params, socket) do
    {:ok, alarm} =
      Alarms.update_alarm(Alarms.get_alarm_by_user_id(socket.assigns.current_user.id), %{
        enabled: false
      })

    # alarm = Alarms.get_alarm_by_user_id(socket.assigns.current_user.id)

    Telegex.send_message(alarm.telegram_chat_id, "Notificacoes desabilitadas!")

    {:noreply, socket |> assign(alarm: alarm) |> put_flash(:info, "Notificacoes desabilitadas!")}
  end
end
