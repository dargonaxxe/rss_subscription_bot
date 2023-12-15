import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rss_subscription_bot_web, RssSubscriptionBotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "j3jhR44m1P4yN8/lBmWWRr6CAqQx+1JEDKlkYrzCtSUpf15uEuqoOKQ3HKC0NOHJ",
  server: false

config :bcrypt_elixir, log_rounds: 4

config :rss_subscription_bot, RssSubscriptionBot.Repo,
  database: "rss_subscription_bot_repo_test",
  username: "user",
  password: "pass",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false
