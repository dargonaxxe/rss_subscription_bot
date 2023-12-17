defmodule RssSubscriptionBot.Core.Feed do
  alias RssSubscriptionBot.Repo
  alias RssSubscriptionBot.Core.Feed.Item

  def add_item(subscription_id, title, content, guid) do
    attrs = %{
      subscription_id: subscription_id,
      title: title,
      content: content,
      guid: guid
    }

    Item.new()
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def get_items(subscription_id) do
    subscription_id
    |> get_items_query()
    |> Repo.all()
  end

  # todo: move to config
  @items_limit 200
  import Ecto.Query

  defp get_items_query(subscription_id) do
    subscription_id
    |> get_all_items_query()
    |> limit(@items_limit)
    |> order_by(desc: :id)
  end

  def get_all_items_query(subscription_id) do
    from(s in Item, where: s.subscription_id == ^subscription_id)
  end
end
