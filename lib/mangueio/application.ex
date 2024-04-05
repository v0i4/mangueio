defmodule Mangueio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ets.new(:results, [:bag, :public, :named_table])

    children = [
      # Start the Telemetry supervisor
      MangueioWeb.Telemetry,
      # Start the Ecto repository
      Mangueio.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mangueio.PubSub},
      # Start Finch
      {Finch, name: Mangueio.Finch},
      # Start the Endpoint (http/https)
      MangueioWeb.Endpoint
      # Start a worker by calling: Mangueio.Worker.start_link(arg)
      #      MangueioWeb.HookHandler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mangueio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MangueioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
