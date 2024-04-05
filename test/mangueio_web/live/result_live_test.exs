defmodule MangueioWeb.ResultLiveTest do
  use MangueioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mangueio.InterestsFixtures

  @create_attrs %{description: "some description", location: "some location", image: "some image", currency: "some currency", url: "some url", price: 42}
  @update_attrs %{description: "some updated description", location: "some updated location", image: "some updated image", currency: "some updated currency", url: "some updated url", price: 43}
  @invalid_attrs %{description: nil, location: nil, image: nil, currency: nil, url: nil, price: nil}

  defp create_result(_) do
    result = result_fixture()
    %{result: result}
  end

  describe "Index" do
    setup [:create_result]

    test "lists all results", %{conn: conn, result: result} do
      {:ok, _index_live, html} = live(conn, ~p"/results")

      assert html =~ "Listing Results"
      assert html =~ result.description
    end

    test "saves new result", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/results")

      assert index_live |> element("a", "New Result") |> render_click() =~
               "New Result"

      assert_patch(index_live, ~p"/results/new")

      assert index_live
             |> form("#result-form", result: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#result-form", result: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/results")

      html = render(index_live)
      assert html =~ "Result created successfully"
      assert html =~ "some description"
    end

    test "updates result in listing", %{conn: conn, result: result} do
      {:ok, index_live, _html} = live(conn, ~p"/results")

      assert index_live |> element("#results-#{result.id} a", "Edit") |> render_click() =~
               "Edit Result"

      assert_patch(index_live, ~p"/results/#{result}/edit")

      assert index_live
             |> form("#result-form", result: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#result-form", result: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/results")

      html = render(index_live)
      assert html =~ "Result updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes result in listing", %{conn: conn, result: result} do
      {:ok, index_live, _html} = live(conn, ~p"/results")

      assert index_live |> element("#results-#{result.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#results-#{result.id}")
    end
  end

  describe "Show" do
    setup [:create_result]

    test "displays result", %{conn: conn, result: result} do
      {:ok, _show_live, html} = live(conn, ~p"/results/#{result}")

      assert html =~ "Show Result"
      assert html =~ result.description
    end

    test "updates result within modal", %{conn: conn, result: result} do
      {:ok, show_live, _html} = live(conn, ~p"/results/#{result}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Result"

      assert_patch(show_live, ~p"/results/#{result}/show/edit")

      assert show_live
             |> form("#result-form", result: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#result-form", result: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/results/#{result}")

      html = render(show_live)
      assert html =~ "Result updated successfully"
      assert html =~ "some updated description"
    end
  end
end
