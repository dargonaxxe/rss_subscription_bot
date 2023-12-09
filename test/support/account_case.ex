defmodule RssSubscriptionBot.AccountCase do
  alias RssSubscriptionBot.RepoCase
  use ExUnit.CaseTemplate
  alias RssSubscriptionBot.Core.AccountFixture
  alias RssSubscriptionBot.Core.Accounts

  using do
    quote do
      use RepoCase

      import AccountFixture, only: [username_valid: 0, pass_valid: 0]

      defp setup_account(_) do
        {:ok, account} = Accounts.create_account(username_valid(), pass_valid())
        %{account: account}
      end
    end
  end
end
