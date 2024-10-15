defmodule Baltimarecms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BaltimarecmsWeb.Telemetry,
      Baltimarecms.Repo,
      {DNSCluster, query: Application.get_env(:baltimarecms, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Baltimarecms.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Baltimarecms.Finch},
      # Start a worker by calling: Baltimarecms.Worker.start_link(arg)
      # {Baltimarecms.Worker, arg},
      # Start to serve requests, typically the last entry
      BaltimarecmsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Baltimarecms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BaltimarecmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
