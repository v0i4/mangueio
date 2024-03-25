defmodule Mangueio.Olx.Scrapper do
  @base_dir_scripts "#{File.cwd!()}/scrappers/"

  def search(query, filters \\ %{}) do
    try do
      query
      |> web_scraping()
      |> handle_data()
      |> apply_filters(filters)
    rescue
      _ -> []
    end
  end

  defp web_scraping(query) do
    {html, status_code} = System.cmd("python3", ["#{@base_dir_scripts}olx.py", query])

    case status_code do
      0 ->
        {:ok, html}

        html
        |> Floki.find("section[data-ds-component='DS-AdCard']")
        |> Enum.map(&parse_ad_card/1)

      _ ->
        {:error, :request_error}
    end
  end

  defp parse_ad_card(ad_card) do
    description =
      ad_card
      |> Floki.find(".olx-ad-card__title")
      |> Floki.text()

    image =
      ad_card
      |> Floki.find("img")
      |> Floki.attribute("src")
      |> List.first()

    url =
      ad_card
      |> Floki.find("a[data-ds-component='DS-NewAdCard-Link']")
      |> Floki.attribute("href")
      |> List.first()

    price =
      ad_card
      |> Floki.find("h3.olx-ad-card__price")
      |> Floki.text()
      |> String.trim()

    location =
      ad_card
      |> Floki.find("div.olx-ad-card__location")
      |> Floki.text()
      |> String.trim()

    %{
      description: description,
      image: image,
      url: url,
      price: price,
      location: location
    }
  end

  defp handle_data(items) do
    items
    |> Enum.map(fn item ->
      price =
        try do
          %{
            value:
              item.price
              |> String.split(" ")
              |> List.last()
              |> String.replace(".", "")
              |> String.to_integer(),
            currency: item.price |> String.split(" ") |> List.first()
          }
        rescue
          _ ->
            %{
              value: 0,
              currency: nil
            }
        end

      %{
        description: item.description,
        image: item.image,
        url: item.url,
        price: price,
        location: item.location
      }
    end)
  end

  defp apply_filters(items, filters) do
    min_price = filters |> Map.get(:min_price) || 0
    max_price = filters |> Map.get(:max_price) || 9_999_999

    items
    |> Enum.filter(fn item ->
      item.price.value >= min_price && item.price.value <= max_price
    end)
  end
end
