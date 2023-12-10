defmodule RssSubscriptionBot.Repo.Migrations.AlterSubscriptionsAddTgHandle do
  use Ecto.Migration

  def change do
    alter table("subscriptions") do
      add(:tg_handle, :string)
    end
  end
end
