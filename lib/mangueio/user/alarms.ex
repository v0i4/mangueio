defmodule Mangueio.User.Alarms do
  @moduledoc """
  The Alarms context.
  """
  import Ecto.Query, warn: false
  alias Mangueio.Repo
  alias Mangueio.User.Alarm

  @doc """
  Returns the list of alarms.

  ## Examples

      iex> list_alarms()
      [%Alarm{}, ...]

  """
  def list_alarms do
    Repo.all(Alarm)
  end

  def get_alarm_by_user_id(user_id) do
    Repo.get_by(Alarm, user_id: user_id)
  end

  @doc """
  Gets a single alarm.

  Raises `Ecto.NoResultsError` if the Alarm does not exist.

  ## Examples

      iex> get_alarm!(123)
      %Alarm{}

      iex> get_alarm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_alarm!(id), do: Repo.get!(Alarm, id)

  @doc """
  Creates a alarm.

  ## Examples

      iex> create_alarm(%{field: value})
      {:ok, %Alarm{}}

      iex> create_alarm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alarm(attrs \\ %{}) do
    %Alarm{}
    |> Alarm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a alarm.

  ## Examples

      iex> update_alarm(alarm, %{field: new_value})
      {:ok, %Alarm{}}

      iex> update_alarm(alarm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}   

  """

  def update_alarm(%Alarm{} = alarm, attrs) do
    alarm
    |> Alarm.changeset(attrs)
    |> Repo.update()
  end
end
