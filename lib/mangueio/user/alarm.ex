defmodule Mangueio.User.Alarm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "alarms" do
    belongs_to :user, Mangueio.Accounts.User
    field :telegram_chat_id, :integer
    field :daily_all, :boolean, default: false
    field :enabled, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(alarm, attrs) do
    alarm
    |> cast(attrs, [:telegram_chat_id, :daily_all, :user_id, :enabled])
    |> validate_required([:telegram_chat_id, :daily_all])
  end
end
