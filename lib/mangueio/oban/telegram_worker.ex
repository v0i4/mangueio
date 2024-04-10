defmodule Mangueio.TelegramWorker do
  use Oban.Worker

  alias Mangueio.Senders.DataHelper

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    DataHelper.send_telegram_notifications()
    :ok
  end
end
