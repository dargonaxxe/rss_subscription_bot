defmodule RssSubscriptionBot.Repo do
  use Ecto.Repo,
    otp_app: :rss_subscription_bot,
    adapter: Ecto.Adapters.Postgres
end
