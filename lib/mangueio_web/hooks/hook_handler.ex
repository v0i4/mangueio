defmodule MangueioWeb.HookHandler do
  use Telegex.Hook.GenHandler

  @impl true
  def on_boot() do
    # read some parameters from your env config
    env_config = Application.get_env(:mangueio, __MODULE__)
    # delete the webhook and set it again
    try do
      {:ok, true} = Telegex.delete_webhook()
    rescue
      _ -> nil
    end

    # set the webhook (url is required)
    # {:ok, true} = Telegex.set_webhook(env_config[:webhook_url])

    # if dev environment

    if Mix.env() == :dev do
      {:ok, true} =
        Telegex.set_webhook("https://eeba-2804-14d-bac2-870d-00-98b8.ngrok-free.app/api/telegram")
    else
      Telegex.set_webhook("https://mangueio.fly.dev/api/telegram")
    end

    %Telegex.Hook.Config{
      secret_token: env_config[:secret_token],
      server_port: 4001
    }
  end

  @impl true
  def on_update(update) do
    # consume the update

    update
    |> IO.inspect()

    :ok
  end
end
