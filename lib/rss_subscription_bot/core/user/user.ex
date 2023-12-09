defmodule RssSubscriptionBot.Core.User do
  alias RssSubscriptionBot.Core.User
  use Ecto.Schema

  schema "users" do
    belongs_to(:account, RssSubscriptionBot.Core.Account)
    timestamps()
  end

  def new() do
    %User{}
  end

  import Ecto.Changeset

  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:account_id])
    |> validate_required([:account_id])
    |> assoc_constraint(:account)
  end
end
