defmodule RssSubscriptionBot.Core.Session do
  alias RssSubscriptionBot.Core.Account
  use Ecto.Schema

  schema "sessions" do
    belongs_to(:account, Account)
    field(:token, :binary)
    field(:valid_until, :naive_datetime)
    timestamps()
  end
end
