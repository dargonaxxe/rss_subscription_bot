defmodule RssSubscriptionBot.Repo.Migrations.CreateSessionsTable do
  use Ecto.Migration

  def change do
    create table("sessions") do
      add(:account_id, references("accounts"))
      add(:token, :binary)
      add(:valid_until, :naive_datetime)
      timestamps()
    end
  end
end
