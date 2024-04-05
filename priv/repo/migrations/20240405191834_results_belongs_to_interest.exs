defmodule Mangueio.Repo.Migrations.ResultsBelongsToInterest do
  use Ecto.Migration

  def change do
    alter table(:results) do
      add :interest_id, references(:interests, on_delete: :delete_all)
    end
  end
end
