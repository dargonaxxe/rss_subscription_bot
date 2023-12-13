defmodule RssSubscriptionBot.Core.Subscription do
  use Ecto.Schema
  alias RssSubscriptionBot.Core.Subscription
  alias RssSubscriptionBot.Core.User

  schema "subscriptions" do
    field(:url, :string)
    field(:tg_handle, :string)
    belongs_to(:user, User)
    timestamps()
  end

  def new() do
    %Subscription{}
  end

  import Ecto.Changeset

  def changeset(%Subscription{} = subscription, attrs \\ %{}) do
    subscription
    |> cast(attrs, [:url, :user_id, :tg_handle])
    |> validate_required([:url, :user_id, :tg_handle])
    |> assoc_constraint(:user)
  end
end
