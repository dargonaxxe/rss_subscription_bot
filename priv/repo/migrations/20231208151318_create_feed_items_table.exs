defmodule RssSubscriptionBot.Repo.Migrations.CreateFeedItemsTable do
  use Ecto.Migration

  def change do
    create table("feed_items") do
      add(:subscription_id, references("subscriptions"))
      add(:content, :text)
      add(:title, :text)

      timestamps()
    end
  end
end
