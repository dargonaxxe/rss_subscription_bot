defmodule RssSubscriptionBot.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add(:account_id, references("accounts"))
      timestamps()
    end
  end
end
