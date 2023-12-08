defmodule RssSubscriptionBot.Core.AccountsTest do
  alias RssSubscriptionBot.Core.AccountFixture
  alias RssSubscriptionBot.Core.Accounts
  use RssSubscriptionBot.RepoCase

  describe "create account" do
    import AccountFixture

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
end
