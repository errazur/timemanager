defmodule Timemachine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Timemachine.Tokens.CSRF,
      TimemachineWeb.Telemetry,
      Timemachine.Repo,
      {DNSCluster, query: Application.get_env(:timemachine, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Timemachine.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Timemachine.Finch},
      # Start a worker by calling: Timemachine.Worker.start_link(arg)
      # {Timemachine.Worker, arg},
      # Start to serve requests, typically the last entry
      TimemachineWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Timemachine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimemachineWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
