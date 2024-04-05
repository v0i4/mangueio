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

  @doc """
  Generate a result.
  """
  def result_fixture(attrs \\ %{}) do
    {:ok, result} =
      attrs
      |> Enum.into(%{
        currency: "some currency",
        description: "some description",
        image: "some image",
        location: "some location",
        price: 42,
        url: "some url"
      })
      |> Mangueio.Interests.create_result()

    result
  end
end
