defmodule RssSubscriptionBot.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add(:username, :string)
      add(:pwd_hash, :binary)
      timestamps()
    end

    unique_index("accounts", :username, name: :accounts_username_unique_index)
    |> create()
  end
end
