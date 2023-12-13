defmodule RssSubscriptionBotWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Phoenix.PubSub

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      telemetry(),
      endpoint(),
      pub_sub()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RssSubscriptionBotWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RssSubscriptionBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp telemetry() do
    RssSubscriptionBotWeb.Telemetry
  end

  defp endpoint() do
    RssSubscriptionBotWeb.Endpoint
  end

  defp pub_sub() do
    {PubSub, name: RssSubscriptionBotWeb.PubSub}
  end
end
