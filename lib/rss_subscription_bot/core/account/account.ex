defmodule RssSubscriptionBot.Core.Account do
  alias RssSubscriptionBot.Core.Account
  use Ecto.Schema

  schema "accounts" do
    field(:username, :string)
    field(:pwd_hash, :binary)
    field(:pwd_string, :string, virtual: true, redact: true)

    timestamps()
  end

  def new do
    %Account{}
  end

  import Ecto.Changeset

  # todo: move to config
  @username_length_min 6
  # todo: move to config
  @pwd_string_length_min 12
  def registration_changeset(%Account{} = account, attrs \\ %{}) do
    account
    |> cast(attrs, [:username, :pwd_hash, :pwd_string])
    |> validate_required([:username, :pwd_string])
    |> validate_length(:username, min: @username_length_min)
    |> validate_length(:pwd_string, min: @pwd_string_length_min)
  end
end
