defmodule RssSubscriptionBot.Core.Accounts do
  alias RssSubscriptionBot.Repo
  alias RssSubscriptionBot.Core.Account

  def create_account(username, pwd_string) do
    attrs = %{
      username: username,
      pwd_string: pwd_string,
      pwd_hash: Bcrypt.hash_pwd_salt(pwd_string)
    }

    Account.new()
    |> Account.registration_changeset(attrs)
    |> Repo.insert()
  end
end
