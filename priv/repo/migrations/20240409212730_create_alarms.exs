defmodule Mangueio.Repo.Migrations.CreateAlarms do
  use Ecto.Migration

  def change do
    create table(:alarms) do
      add :telegram_chat_id, :integer
      add :daily_all, :boolean, default: false, null: false

      timestamps()
    end
  end
end
