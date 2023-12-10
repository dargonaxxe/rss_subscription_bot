defmodule RssSubscriptionBot.Core.Users do
  alias RssSubscriptionBot.Repo
  alias RssSubscriptionBot.Core.User

  def create_user(account_id) do
    attrs = %{account_id: account_id}

    User.new() |> User.changeset(attrs) |> Repo.insert()
  end
end
