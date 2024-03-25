defmodule Mangueio.Scrapper do
  def olx_request(query) do
    {html, status_code} =
      System.cmd("python3", ["/home/v0i4/dev/mangueio/scraper/scraper.py", query])

    case status_code do
      0 ->
        {:ok, html}

        html
        |> Floki.find("section[data-ds-component='DS-AdCard']")
        |> Enum.map(&parse_ad_card/1)
        |> handle_data

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
end
