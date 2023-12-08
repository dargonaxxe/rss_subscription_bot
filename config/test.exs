import Config

config :bcrypt_elixir, log_rounds: 4

config :rss_subscription_bot, RssSubscriptionBot.Repo,
  database: "rss_subscription_bot_repo",
  username: "user",
  password: "pass",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false
