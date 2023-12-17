defmodule RssSubscriptionBot.Core.Subscriptions do
  alias Ecto.Multi
  alias RssSubscriptionBot.Core.Feed
  alias RssSubscriptionBot.Core.TgUsers
  alias RssSubscriptionBot.Repo
  alias RssSubscriptionBot.Core.Subscription

  # todo: fix tests
  def create_subscription(user_id, url, tg_handle, name) do
    attrs = %{
      user_id: user_id,
      url: url,
      tg_handle: tg_handle,
      name: name
    }

    Subscription.new()
    |> Subscription.changeset(attrs)
    |> validate_tg_handle(tg_handle)
    |> Repo.insert()
  end

  defp validate_tg_handle(changeset, tg_handle) do
    tg_user = tg_handle |> TgUsers.find_by_handle()

    changeset
    |> validate_tg_user(tg_user)
  end

  defp validate_tg_user(changeset, %{}), do: changeset

  defp validate_tg_user(changeset, nil) do
    import Ecto.Changeset, only: [add_error: 4]
    changeset |> add_error(:tg_handle, "Unknown user", [])
  end

  def get_subscriptions(user_id) do
    user_id
    |> get_subscriptions_query()
    |> Repo.all()
  end

  def get_subscription!(id) do
    Repo.get_by!(Subscription, id: id)
  end

  import Ecto.Query

  def delete_subscription(subscription) do
    Multi.new()
    |> Multi.delete_all("delete feed items", subscription.id |> Feed.get_all_items_query())
    |> Multi.delete("delete subscription", subscription)
    |> Repo.transaction()
  end

  defp get_subscriptions_query(user_id) do
    from(s in Subscription, where: s.user_id == ^user_id)
  end
end
