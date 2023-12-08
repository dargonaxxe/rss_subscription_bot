defmodule RssSubscriptionBot.Core.User do
  use Ecto.Schema

  schema "users" do
    belongs_to(:account, RssSubscriptionBot.Core.Account)
    timestamps()
  end
end
