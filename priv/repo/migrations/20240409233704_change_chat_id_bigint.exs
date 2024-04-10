defmodule Mangueio.Repo.Migrations.ChangeChatIdBigint do
  use Ecto.Migration

  def change do
    alter table(:alarms) do
      modify :telegram_chat_id, :bigint
    end
  end
end
