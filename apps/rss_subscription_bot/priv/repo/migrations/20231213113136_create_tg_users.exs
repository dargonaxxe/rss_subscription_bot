defmodule RssSubscriptionBot.Repo.Migrations.CreateTgUsers do
  use Ecto.Migration

  def change do
    create table("tg_users", primary_key: false) do
      add(:tg_id, :id, primary_key: true)
      add(:handle, :string)
      timestamps()
    end
  end
end
