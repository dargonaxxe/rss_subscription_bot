defmodule RssSubscriptionBot.Core.Subscriptions do
  alias RssSubscriptionBot.Repo
  alias RssSubscriptionBot.Core.Subscription

  def create_subscription(user_id, url) do
    attrs = %{
      user_id: user_id,
      url: url
    }

    Subscription.new()
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end
end
