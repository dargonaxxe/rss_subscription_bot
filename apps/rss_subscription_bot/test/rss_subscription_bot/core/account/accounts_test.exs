defmodule RssSubscriptionBot.Core.AccountsTest do
  alias RssSubscriptionBot.Core.AccountFixture
  alias RssSubscriptionBot.Core.Accounts
  use RssSubscriptionBot.RepoCase
  import AccountFixture

  describe "create account" do
    test "should create account" do
      {:ok, _} = Accounts.create_account(username_valid(), pass_valid())
    end

    test "should not create duplicating account" do
      {:ok, _} = Accounts.create_account(username_valid(), pass_valid())

      {:error, %{errors: [username: {_, [constraint: :unique, constraint_name: _]}]}} =
        Accounts.create_account(username_valid(), pass_valid())
    end

    test "should not create user with invalid username" do
      {:error, %{errors: [username: _]}} =
        Accounts.create_account(username_invalid(), pass_valid())
    end

    test "should not create user with invalid password" do
      {:error, %{errors: [pwd_string: _]}} =
        Accounts.create_account(username_valid(), pass_invalid())
    end
  end

  describe "get_account_by_id" do
    test "should return an account" do
      keys_to_compare = [:username, :pwd_hash, :inserted_at, :updated_at]
      {:ok, account_1} = Accounts.create_account(username_valid(), pass_valid())
      account_2 = Accounts.get_account_by_id(account_1.id)

      for key <- keys_to_compare do
        assert account_1 |> Map.get(key) == account_2 |> Map.get(key)
      end
    end
  end
end
