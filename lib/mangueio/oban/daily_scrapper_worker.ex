defmodule Mangueio.Oban.DailyScrapperWorker do
  use Oban.Worker

  alias Telegex
  alias Mangueio.Interests
  alias Mangueio.Interests.Interest
  alias Mangueio.Repo
  alias Interests.Result
  import Ecto.Query

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    run()
    :ok
  end

  def run() do
    _old_results =
      Repo.all(
        from r in Result,
          select: r
      )
      |> Enum.map(fn result ->
        Interests.delete_result(result)
      end)

    interests =
      Repo.all(
        from i in Interest,
          select: i
      )

    interests
    |> Enum.each(fn interest ->
      search_params =
        interest
        |> Map.from_struct()

      filters = %{
        min_price: search_params.min_price,
        max_price: search_params.max_price,
        location: "SC"
      }

      results = Interests.merge_results_and_interests(interest.keyword, filters, interest.id)

      results
      |> Enum.map(fn item ->
        item =
          item
          |> Map.put(:currency, item.price.currency)
          |> Map.put(:price, item.price.value)

        try do
          Interests.create_result(item)
        rescue
          Ecto.ConstraintError ->
            to_update = Interests.get_result_by_url(item.url)
            Interests.update_result(to_update, item)
        end
      end)
    end)
  end
end
