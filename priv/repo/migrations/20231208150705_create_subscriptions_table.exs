defmodule RssSubscriptionBot.Repo.Migrations.CreateSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table("subscriptions") do
      add(:url, :string)
      add(:user_id, references("users"))
      timestamps()
    end
  end
end
