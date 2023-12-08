defmodule RssSubscriptionBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :rss_subscription_bot,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RssSubscriptionBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "0.16.0"},
      {:fast_rss, "0.5.0"},
      {:ecto_sql, "3.11.1"},
      {:postgrex, "0.17.4"}
    ]
  end
end
