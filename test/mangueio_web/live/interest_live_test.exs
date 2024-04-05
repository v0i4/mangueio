defmodule MangueioWeb.InterestLiveTest do
  use MangueioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mangueio.InterestsFixtures

  @create_attrs %{location: "some location", keyword: "some keyword", min_price: 42, max_price: 42}
  @update_attrs %{location: "some updated location", keyword: "some updated keyword", min_price: 43, max_price: 43}
  @invalid_attrs %{location: nil, keyword: nil, min_price: nil, max_price: nil}

  defp create_interest(_) do
    interest = interest_fixture()
    %{interest: interest}
  end

  describe "Index" do
    setup [:create_interest]

    test "lists all interests", %{conn: conn, interest: interest} do
      {:ok, _index_live, html} = live(conn, ~p"/interests")

      assert html =~ "Listing Interests"
      assert html =~ interest.location
    end

    test "saves new interest", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/interests")

      assert index_live |> element("a", "New Interest") |> render_click() =~
               "New Interest"

      assert_patch(index_live, ~p"/interests/new")

      assert index_live
             |> form("#interest-form", interest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#interest-form", interest: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/interests")

      html = render(index_live)
      assert html =~ "Interest created successfully"
      assert html =~ "some location"
    end

    test "updates interest in listing", %{conn: conn, interest: interest} do
      {:ok, index_live, _html} = live(conn, ~p"/interests")

      assert index_live |> element("#interests-#{interest.id} a", "Edit") |> render_click() =~
               "Edit Interest"

      assert_patch(index_live, ~p"/interests/#{interest}/edit")

      assert index_live
             |> form("#interest-form", interest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#interest-form", interest: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/interests")

      html = render(index_live)
      assert html =~ "Interest updated successfully"
      assert html =~ "some updated location"
    end

    test "deletes interest in listing", %{conn: conn, interest: interest} do
      {:ok, index_live, _html} = live(conn, ~p"/interests")

      assert index_live |> element("#interests-#{interest.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#interests-#{interest.id}")
    end
  end

  describe "Show" do
    setup [:create_interest]

    test "displays interest", %{conn: conn, interest: interest} do
      {:ok, _show_live, html} = live(conn, ~p"/interests/#{interest}")

      assert html =~ "Show Interest"
      assert html =~ interest.location
    end

    test "updates interest within modal", %{conn: conn, interest: interest} do
      {:ok, show_live, _html} = live(conn, ~p"/interests/#{interest}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Interest"

      assert_patch(show_live, ~p"/interests/#{interest}/show/edit")

      assert show_live
             |> form("#interest-form", interest: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#interest-form", interest: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/interests/#{interest}")

      html = render(show_live)
      assert html =~ "Interest updated successfully"
      assert html =~ "some updated location"
    end
  end
end
