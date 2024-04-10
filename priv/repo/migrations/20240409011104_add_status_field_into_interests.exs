defmodule Mangueio.Repo.Migrations.AddStatusFieldIntoInterests do
  use Ecto.Migration

  def change do
    alter table(:interests) do
      add :status, :string
      # create(unique_index(:interests, [:url]))
    end
  end
end
