import Config

config :rss_subscription_bot, RssSubscriptionBot.Repo,
  database: "rss_subscription_bot_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :telegex, token: System.get_env("DEV_RSS_SUBSCRIPTION_BOT_TOKEN")
