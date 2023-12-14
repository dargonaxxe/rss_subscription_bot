import Config

config :rss_subscription_bot_web,
  ecto_repos: [RssSubscriptionBot.Repo]

# Configures the endpoint
config :rss_subscription_bot_web, RssSubscriptionBotWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: RssSubscriptionBotWeb.ErrorHTML, json: RssSubscriptionBotWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RssSubscriptionBotWeb.PubSub,
  live_view: [signing_salt: "2vh8UeIA"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/rss_subscription_bot_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/rss_subscription_bot_web/assets", __DIR__)
  ]

config :rss_subscription_bot, ecto_repos: [RssSubscriptionBot.Repo]
config :telegex, caller_adapter: Finch

import_config("#{config_env()}.exs")
