import Config

config :rss_subscription_bot, ecto_repos: [RssSubscriptionBot.Repo]
config :telegex, caller_adapter: Finch

import_config("#{config_env()}.exs")
