defmodule RssSubscriptionBot.Core.Feed.Item do
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
    |> validate_required([:subscription_id, :title, :content, :guid])
    |> assoc_constraint(:subscription)
    |> unique_constraint([:subscription_id, :guid])
  end
end
