defmodule RssSubscriptionBot.Application do
  use Application

  def start(_, _) do
    children =
      [
        finch(),
        repo(),
        registry(),
        users_dynamic_supervisor(),
        users_subscription_observer(),
        telegram_api(),
        polling_handler()
      ]
      |> Enum.filter(fn x -> x != nil end)

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

  defp users_dynamic_supervisor do
    {DynamicSupervisor, strategy: :one_for_one, name: RssSubscriptionBot.UsersDynamicSupervisor}
  end

  defp users_subscription_observer do
    {RssSubscriptionBot.Rss.Otp.UsersSubscriptionObserver, []}
  end

  defp telegram_api do
    {RssSubscriptionBot.Telegram.Domain.TelegramApi, []}
  end

  defp polling_handler do
    case Mix.env() do
      :test ->
        nil

      _ ->
        {RssSubscriptionBot.Telegram.PollingHandler, []}
    end
  end
end
