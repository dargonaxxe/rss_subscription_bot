defmodule RssSubscriptionBot.Application do
  use Application

  def start(_, _) do
    children = [finch(), repo(), registry()]

    opts = [strategy: :one_for_one, name: RssSubscriptionBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp finch() do
    {
      Finch,
      # todo: move name to config
      name: RssSubscriptionBot.Finch,
      pools: %{
        # todo: move size to config
        :default => [size: 10]
      }
    }
  end

  defp repo() do
    RssSubscriptionBot.Repo
  end

  defp registry() do
    {Registry, keys: :unique, name: RssSubscriptionBot.Registry}
  end
end
