defmodule Mangueio.Scrapper.OLXTest do
  use ExUnit.Case
  alias Mangueio.Scrapper.OLX

  test "search/1" do
    assert OLX.search("iphone") != []
    assert OLX.search("lllllllllllllllll") == []
  end

  test "search/2" do
    iphones_all = OLX.search("iphone")
    iphones_some = OLX.search("iphone", %{min_price: 2000, max_price: 5000})
    assert length(iphones_all) > length(iphones_some)
  end
end
