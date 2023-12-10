defmodule RssSubscriptionBot.UserCase do
  alias RssSubscriptionBot.Core.Users
  alias RssSubscriptionBot.AccountCase
  use ExUnit.CaseTemplate

  using do
    quote do
      use AccountCase

      setup [:setup_account]

      defp setup_user(%{account: %{id: account_id}}) do
        {:ok, user} = Users.create_user(account_id)
        %{user: user}
      end
    end
  end
end
