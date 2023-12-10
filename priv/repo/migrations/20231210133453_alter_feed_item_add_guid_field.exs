defmodule RssSubscriptionBot.Repo.Migrations.AlterFeedItemAddGuidField do
  use Ecto.Migration

  def change do
    alter table("feed_items") do
      add(:guid, :string)
    end

    create(index("feed_items", [:guid, :subscription_id], unique: true))
  end
end
