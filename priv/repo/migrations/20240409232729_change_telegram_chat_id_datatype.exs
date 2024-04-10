defmodule Mangueio.Repo.Migrations.ChangeTelegramChatIdDatatype do
  use Ecto.Migration

  def change do
    alter table(:alarms) do
      modify :telegram_chat_id, :integer
    end
  end
end
