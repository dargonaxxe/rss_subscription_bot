defmodule RssSubscriptionBot.Core.TgUser do
  use Ecto.Schema

  schema "tg_users" do
    field(:tg_id, :id, primary_key: true)
    field(:handle, :string)
    timestamps()
  end
end
