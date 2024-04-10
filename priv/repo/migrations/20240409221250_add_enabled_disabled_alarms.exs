defmodule Mangueio.Repo.Migrations.AddEnabledDisabledAlarms do
  use Ecto.Migration

  def change do
    alter table(:alarms) do
      add :enabled, :boolean, default: false
    end
  end
end
