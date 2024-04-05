defmodule Mangueio.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :url, :string
      add :image, :string
      add :price, :integer
      add :currency, :string
      add :description, :string
      add :location, :string

      timestamps()
    end
  end
end
