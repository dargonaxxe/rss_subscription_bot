defmodule RssSubscriptionBot.Core.Account do
  use Ecto.Schema

  schema "accounts" do
    field(:username, :string)
    field(:pwd_hash, :binary)
    timestamps()
  end
end
