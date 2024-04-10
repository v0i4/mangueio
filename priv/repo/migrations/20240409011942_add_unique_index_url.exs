defmodule Mangueio.Repo.Migrations.AddUniqueIndexUrl do
  use Ecto.Migration

  def change do
    create unique_index(:results, [:url])
  end
end
