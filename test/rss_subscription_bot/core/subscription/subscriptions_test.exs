defmodule RssSubscriptionBot.Core.SubscriptionsTest do
  alias RssSubscriptionBot.Core.Users
  alias RssSubscriptionBot.Core.Accounts
  alias RssSubscriptionBot.Core.Subscriptions
  alias RssSubscriptionBot.UserCase
  use UserCase

  setup [:setup_user]

  defp create_subscription(user_id, url) do
    {:ok, sub} = Subscriptions.create_subscription(user_id, url)
    sub
  end

  describe "create subscription" do
    test "should fail when user does not exist", %{user: %{id: user_id}} do
      {:error,
       %{errors: [user: {_, [constraint: :assoc, constraint_name: "subscriptions_user_id_fkey"]}]}} =
        Subscriptions.create_subscription(user_id + 1, "url")
    end

    test "should successfully create subscription when user is present", %{user: %{id: user_id}} do
      {:ok, _} = Subscriptions.create_subscription(user_id, "url")
    end
  end

  describe "get subscriptions, single user" do
    test "should return nothing when user does not exist", %{user: %{id: user_id}} do
      assert Subscriptions.get_subscriptions(user_id + 1) == []
    end

    test "should return nothing when user got no subs", %{user: %{id: user_id}} do
      assert Subscriptions.get_subscriptions(user_id) == []
    end

    test "should return all subs when user is single", %{user: %{id: user_id}} do
      create_sub = &create_subscription(user_id, &1)
      sub_1 = create_sub.("url_1")
      sub_2 = create_sub.("url_2")
      expected_result = [sub_1, sub_2]

      assert Subscriptions.get_subscriptions(user_id) == expected_result
    end
  end

  describe "get subscriptions, multiple users" do
    setup %{} do
      {:ok, account_1} = Accounts.create_account("username_1", pass_valid())
      {:ok, account_2} = Accounts.create_account("username_2", pass_valid())
      {:ok, user_1} = Users.create_user(account_1.id)
      {:ok, user_2} = Users.create_user(account_2.id)
      %{account_1: account_1, account_2: account_2, user_1: user_1, user_2: user_2}
    end

    test "should return only belonging subscriptions", %{user_1: user_1, user_2: user_2} do
      sub_1 = create_subscription(user_1.id, "url_1")
      sub_2 = create_subscription(user_2.id, "url_2")

      assert Subscriptions.get_subscriptions(user_1.id) == [sub_1]
      assert Subscriptions.get_subscriptions(user_2.id) == [sub_2]
    end
  end
end
