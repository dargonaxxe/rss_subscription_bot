import Config

config :rss_subscription_bot, ecto_repos: [RssSubscriptionBot.Repo]

import_config("#{config_env()}.exs")
