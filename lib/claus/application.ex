defmodule Claus.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ClausWeb.Telemetry,
      # Start the Ecto repository
      Claus.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Claus.PubSub},
      # Start Finch
      {Finch, name: Claus.Finch},
      # Start the Endpoint (http/https)
      ClausWeb.Endpoint
      # Start a worker by calling: Claus.Worker.start_link(arg)
      # {Claus.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Claus.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClausWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
