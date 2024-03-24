defmodule Mangueio.Repo do
  use Ecto.Repo,
    otp_app: :mangueio,
    adapter: Ecto.Adapters.Postgres
end
