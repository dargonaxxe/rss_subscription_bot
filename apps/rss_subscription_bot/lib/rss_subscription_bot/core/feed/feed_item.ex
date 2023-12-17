defmodule RssSubscriptionBot.Core.Feed.Item do
  alias RssSubscriptionBot.Rss.Domain.RssItem
  alias RssSubscriptionBot.Core.Feed.Item
  alias RssSubscriptionBot.Core.Subscription
  use Ecto.Schema

  schema "feed_items" do
    belongs_to(:subscription, Subscription)
    field(:title, :string)
    field(:content, :string)
    field(:guid, :string)
    timestamps()
  end

  def new do
    %Item{}
  end

  import Ecto.Changeset

  def changeset(%Item{} = item, attrs \\ %{}) do
    item
    |> cast(attrs, [:subscription_id, :title, :content, :guid])
    |> validate_required([:subscription_id, :title, :guid])
    |> assoc_constraint(:subscription)
    |> unique_constraint([:subscription_id, :guid], name: "feed_items_guid_subscription_id_index")
  end

  def to_domain(%__MODULE__{} = item) do
    %RssItem{
      subscription_id: item.subscription_id,
      title: item.title,
      content: item.content,
      guid: item.guid
    }
  end
end
