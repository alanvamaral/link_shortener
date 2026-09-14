defmodule LinkShortener.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LinkShortenerWeb.Telemetry,
      LinkShortener.Repo,
      {DNSCluster, query: Application.get_env(:link_shortener, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LinkShortener.PubSub},
      LinkShortenerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LinkShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    LinkShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
