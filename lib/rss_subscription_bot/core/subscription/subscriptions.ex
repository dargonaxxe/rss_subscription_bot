defmodule RssSubscriptionBot.Core.Subscriptions do
  alias RssSubscriptionBot.Repo
  alias RssSubscriptionBot.Core.Subscription

  def create_subscription(user_id, url, tg_handle) do
    attrs = %{
      user_id: user_id,
      url: url,
      tg_handle: tg_handle
    }

    Subscription.new()
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  def get_subscriptions(user_id) do
    user_id
    |> get_subscriptions_query()
    |> Repo.all()
  end

  import Ecto.Query

  defp get_subscriptions_query(user_id) do
    from(s in Subscription, where: s.user_id == ^user_id)
  end
end
