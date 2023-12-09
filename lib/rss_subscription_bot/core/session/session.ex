defmodule RssSubscriptionBot.Core.Session do
  alias RssSubscriptionBot.Core.Account
  use Ecto.Schema

  alias RssSubscriptionBot.Core.Session

  schema "sessions" do
    belongs_to(:account, Account)
    field(:token, :binary)
    field(:valid_until, :naive_datetime)
    timestamps()
  end

  def new() do
    %Session{}
  end

  import Ecto.Changeset

  def sign_in_changeset(%Session{} = session, attrs \\ %{}) do
    session
    |> cast(attrs, [:account_id, :token, :valid_until])
    |> validate_required([:account_id, :token, :valid_until])
    |> assoc_constraint(:account)
    |> check_constraint(:valid_until, name: :sessions_valid_until_constraint)
  end
end
