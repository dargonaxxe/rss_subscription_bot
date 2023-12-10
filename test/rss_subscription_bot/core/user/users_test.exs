defmodule RssSubscriptionBot.Core.UsersTest do
  alias RssSubscriptionBot.Core.Users
  alias RssSubscriptionBot.AccountCase
  use AccountCase

  describe "create user" do
    setup [:setup_account]

    test "should fail when account does not exist", %{account: %{id: account_id}} do
      {:error, %{errors: [account: _]}} = Users.create_user(account_id + 1)
    end

    test "should successfully create user when account exists", %{account: %{id: account_id}} do
      {:ok, _} = Users.create_user(account_id)
    end
  end
end
