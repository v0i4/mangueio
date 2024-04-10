# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mangueio,
  ecto_repos: [Mangueio.Repo]

# Configures the endpoint
config :mangueio, MangueioWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: MangueioWeb.ErrorHTML, json: MangueioWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Mangueio.PubSub,
  live_view: [signing_salt: "j1lN7ziu"],
  certfile: "/priv/server.crt",
  keyfile: "/priv/server.key"

config :telegex, token: System.get_env("TELEGRAM_BOT_TOKEN")
config :telegex, caller_adapter: Finch
config :telegex, caller_adapter: {Finch, [receive_timeout: 5 * 1000]}
# config :telegex, caller_adapter: {HTTPoison, [recv_timeout: 5 * 1000]}
config :telegex, hook_adapter: Bandit
# config :telegex, hook_adapter: Cowboy

config :mangueio, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 10],
  repo: Mangueio.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
    {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)},
    {Oban.Plugins.Cron,
     crontab: [
       {"0 11 * * *", Mangueio.Oban.TelegramWorker, []},
       {"0 10 * * *", Mangueio.Oban.DailyScrapperWorker, []},
       {"0 9 * * THU", Mangueio.Oban.ClearCacheWorker, []},
       {"0 9 * * SUN", Mangueio.Oban.ClearCacheWorker, []}
       # {"0 0 * * *", MyApp.DailyWorker, max_attempts: 1},
       # {"0 12 * * MON", MyApp.MondayWorker, queue: :scheduled, tags: ["mondays"]},
       # {"@daily", MyApp.AnotherDailyWorker}
     ]}
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :mangueio, Mangueio.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
