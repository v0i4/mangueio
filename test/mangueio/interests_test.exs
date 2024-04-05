defmodule Mangueio.InterestsTest do
  use Mangueio.DataCase

  alias Mangueio.Interests

  describe "interests" do
    alias Mangueio.Interests.Interest

    import Mangueio.InterestsFixtures

    @invalid_attrs %{location: nil, keyword: nil, min_price: nil, max_price: nil}

    test "list_interests/0 returns all interests" do
      interest = interest_fixture()
      assert Interests.list_interests() == [interest]
    end

    test "get_interest!/1 returns the interest with given id" do
      interest = interest_fixture()
      assert Interests.get_interest!(interest.id) == interest
    end

    test "create_interest/1 with valid data creates a interest" do
      valid_attrs = %{location: "some location", keyword: "some keyword", min_price: 42, max_price: 42}

      assert {:ok, %Interest{} = interest} = Interests.create_interest(valid_attrs)
      assert interest.location == "some location"
      assert interest.keyword == "some keyword"
      assert interest.min_price == 42
      assert interest.max_price == 42
    end

    test "create_interest/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interests.create_interest(@invalid_attrs)
    end

    test "update_interest/2 with valid data updates the interest" do
      interest = interest_fixture()
      update_attrs = %{location: "some updated location", keyword: "some updated keyword", min_price: 43, max_price: 43}

      assert {:ok, %Interest{} = interest} = Interests.update_interest(interest, update_attrs)
      assert interest.location == "some updated location"
      assert interest.keyword == "some updated keyword"
      assert interest.min_price == 43
      assert interest.max_price == 43
    end

    test "update_interest/2 with invalid data returns error changeset" do
      interest = interest_fixture()
      assert {:error, %Ecto.Changeset{}} = Interests.update_interest(interest, @invalid_attrs)
      assert interest == Interests.get_interest!(interest.id)
    end

    test "delete_interest/1 deletes the interest" do
      interest = interest_fixture()
      assert {:ok, %Interest{}} = Interests.delete_interest(interest)
      assert_raise Ecto.NoResultsError, fn -> Interests.get_interest!(interest.id) end
    end

    test "change_interest/1 returns a interest changeset" do
      interest = interest_fixture()
      assert %Ecto.Changeset{} = Interests.change_interest(interest)
    end
  end

  describe "results" do
    alias Mangueio.Interests.Result

    import Mangueio.InterestsFixtures

    @invalid_attrs %{description: nil, location: nil, image: nil, currency: nil, url: nil, price: nil}

    test "list_results/0 returns all results" do
      result = result_fixture()
      assert Interests.list_results() == [result]
    end

    test "get_result!/1 returns the result with given id" do
      result = result_fixture()
      assert Interests.get_result!(result.id) == result
    end

    test "create_result/1 with valid data creates a result" do
      valid_attrs = %{description: "some description", location: "some location", image: "some image", currency: "some currency", url: "some url", price: 42}

      assert {:ok, %Result{} = result} = Interests.create_result(valid_attrs)
      assert result.description == "some description"
      assert result.location == "some location"
      assert result.image == "some image"
      assert result.currency == "some currency"
      assert result.url == "some url"
      assert result.price == 42
    end

    test "create_result/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interests.create_result(@invalid_attrs)
    end

    test "update_result/2 with valid data updates the result" do
      result = result_fixture()
      update_attrs = %{description: "some updated description", location: "some updated location", image: "some updated image", currency: "some updated currency", url: "some updated url", price: 43}

      assert {:ok, %Result{} = result} = Interests.update_result(result, update_attrs)
      assert result.description == "some updated description"
      assert result.location == "some updated location"
      assert result.image == "some updated image"
      assert result.currency == "some updated currency"
      assert result.url == "some updated url"
      assert result.price == 43
    end

    test "update_result/2 with invalid data returns error changeset" do
      result = result_fixture()
      assert {:error, %Ecto.Changeset{}} = Interests.update_result(result, @invalid_attrs)
      assert result == Interests.get_result!(result.id)
    end

    test "delete_result/1 deletes the result" do
      result = result_fixture()
      assert {:ok, %Result{}} = Interests.delete_result(result)
      assert_raise Ecto.NoResultsError, fn -> Interests.get_result!(result.id) end
    end

    test "change_result/1 returns a result changeset" do
      result = result_fixture()
      assert %Ecto.Changeset{} = Interests.change_result(result)
    end
  end
end
