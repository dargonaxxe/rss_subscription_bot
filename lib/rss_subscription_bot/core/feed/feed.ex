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
end
