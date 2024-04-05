defmodule Mangueio.InterestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mangueio.Interests` context.
  """

  @doc """
  Generate a interest.
  """
  def interest_fixture(attrs \\ %{}) do
    {:ok, interest} =
      attrs
      |> Enum.into(%{
        keyword: "some keyword",
        location: "some location",
        max_price: 42,
        min_price: 42
      })
      |> Mangueio.Interests.create_interest()

    interest
  end
end
