defmodule RssSubscriptionBot.Core.Subscription do
  use Ecto.Schema
  alias RssSubscriptionBot.Core.User

  schema "subscriptions" do
    field(:url, :string)
    belongs_to(:user, User)
    timestamps()
  end
end
