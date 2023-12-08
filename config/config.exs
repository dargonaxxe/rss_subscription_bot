import Config

config :rss_subscription_bot, RssSubscriptionBot.Repo,
  database: "rss_subscription_bot_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :rss_subscription_bot, ecto_repos: [RssSubscriptionBot.Repo]

import_config("#{config_env()}.exs")
