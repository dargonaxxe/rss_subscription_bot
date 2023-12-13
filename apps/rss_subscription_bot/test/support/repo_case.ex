defmodule RssSubscriptionBot.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias RssSubscriptionBot.Repo

      import RssSubscriptionBot.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RssSubscriptionBot.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(RssSubscriptionBot.Repo, {:shared, self()})
    end

    :ok
  end
end
