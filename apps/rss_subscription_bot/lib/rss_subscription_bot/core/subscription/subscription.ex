defmodule RssSubscriptionBot.Core.Subscription do
  use Ecto.Schema
  alias RssSubscriptionBot.Core.Subscription
  alias RssSubscriptionBot.Core.User

  schema "subscriptions" do
    field(:name, :string)
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
    |> cast(attrs, [:url, :user_id, :tg_handle, :name])
    |> validate_required([:url, :user_id, :tg_handle, :name])
    |> validate_url()
    |> assoc_constraint(:user)
  end

  defp validate_url(%{changes: changes} = changeset) do
    url = changes |> Map.get(:url)

    if is_valid?(url) do
      changeset
    else
      changeset |> add_error(:url, "Invalid url")
    end
  end

  defp is_valid?(nil), do: false

  # suggested url validation from stackoverflow 
  defp is_valid?(url) do
    uri = url |> URI.parse()
    uri.scheme != nil && uri.host =~ "."
  end
end
