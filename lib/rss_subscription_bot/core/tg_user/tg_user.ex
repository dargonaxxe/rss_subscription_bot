defmodule RssSubscriptionBot.Core.TgUser do
  use Ecto.Schema

  schema "tg_users" do
    field(:tg_id, :id, primary_key: true)
    field(:handle, :string)
    timestamps()
  end

  def new() do
    %__MODULE__{}
  end

  import Ecto.Changeset

  def changeset(%__MODULE__{} = tg_user, attrs \\ %{}) do
    tg_user
    |> cast(attrs, [:tg_id, :handle])
    |> validate_required([:tg_id, :handle])
  end
end
