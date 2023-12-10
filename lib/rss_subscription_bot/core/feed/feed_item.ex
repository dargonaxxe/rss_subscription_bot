defmodule RssSubscriptionBot.Core.Feed.Item do
  alias RssSubscriptionBot.Core.Subscription
  use Ecto.Schema

  schema "feed_items" do
    belongs_to(:subscription, Subscription)
    field(:title, :string)
    field(:content, :string)
    field(:guid, :string)
    timestamps()
  end
end
