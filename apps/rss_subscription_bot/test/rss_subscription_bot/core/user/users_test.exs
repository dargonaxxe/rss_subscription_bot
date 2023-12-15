defmodule RssSubscriptionBot.Core.UsersTest do
  alias RssSubscriptionBot.Core.Accounts
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

  describe "get_users" do
    test "should return all users" do
      {:ok, account_1} = Accounts.create_account("username_1", pass_valid())
      {:ok, account_2} = Accounts.create_account("username_2", pass_valid())
      {:ok, user_1} = Users.create_user(account_1.id)
      {:ok, user_2} = Users.create_user(account_2.id)
      expected_users = [user_2, user_1]

      # at the moment I don't care about order
      assert Users.get_users() |> MapSet.new() == expected_users |> MapSet.new()
    end
  end

  describe "get_user_by_id" do
    setup [:setup_account]

    test "should return user", %{account: %{id: account_id}} do
      {:ok, user_1} = Users.create_user(account_id)
      user_2 = Users.get_user_by_id(user_1.id)

      assert user_1 == user_2
    end
  end

  describe "get_user_by_account_id" do
    setup [:setup_account]

    test "should return user", %{account: %{id: account_id}} do
      {:ok, user_1} = Users.create_user(account_id)
      user_2 = Users.get_user_by_account_id(account_id)

      assert user_1 == user_2
    end
  end
end
