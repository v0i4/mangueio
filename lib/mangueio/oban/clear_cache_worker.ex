defmodule Mangueio.Oban.ClearCacheWorker do
  use Oban.Worker

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    :ets.delete(:notifications)
    :ets.new(:notifications, [:bag, :public, :named_table])
    :ok
  end
end
