defmodule RssSubscriptionBot.Core.TgUsers do
  alias RssSubscriptionBot.Repo
  alias RssSubscriptionBot.Core.TgUser

  def new_user(tg_id, handle) do
    attrs = %{tg_id: tg_id, handle: handle}

    TgUser.new()
    |> TgUser.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: :tg_id)
  end

  def find_by_handle(handle) do
    Repo.get_by(TgUser, handle: handle)
  end
end
