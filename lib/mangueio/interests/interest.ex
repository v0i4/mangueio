defmodule Mangueio.Interests.Interest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "interests" do
    belongs_to :user, Mangueio.Accounts.User
    field :location, :string
    field :keyword, :string
    field :min_price, :integer
    field :max_price, :integer
    field :status, :string, default: "Processamento.."
    has_many :results, Mangueio.Interests.Result
    timestamps()
  end

  @doc false
  def changeset(interest, attrs) do
    interest
    |> cast(attrs, [:keyword, :location, :min_price, :max_price, :user_id, :status])
    |> validate_required([:keyword, :location, :min_price, :max_price, :user_id])
  end
end
