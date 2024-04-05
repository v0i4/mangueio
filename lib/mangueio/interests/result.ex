defmodule Mangueio.Interests.Result do
  use Ecto.Schema
  import Ecto.Changeset

  schema "results" do
    belongs_to :interest, Mangueio.Interests.Interest
    field :description, :string
    field :location, :string
    field :image, :string
    field :currency, :string
    field :url, :string
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, [:url, :image, :price, :currency, :description, :location, :interest_id])
    |> validate_required([:url, :image, :price, :currency, :description, :location])
  end
end
