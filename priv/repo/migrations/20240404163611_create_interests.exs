defmodule Mangueio.Repo.Migrations.CreateInterests do
  use Ecto.Migration

  def change do
    create table(:interests) do
      add :keyword, :string
      add :location, :string
      add :min_price, :integer
      add :max_price, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:interests, [:user_id])
  end
end
