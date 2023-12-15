defmodule RssSubscriptionBot.Core.FeedTest do
  alias RssSubscriptionBot.Core.Subscriptions
  alias RssSubscriptionBot.Core.Users
  alias RssSubscriptionBot.Core.Accounts
  alias RssSubscriptionBot.Core.Feed
  alias RssSubscriptionBot.SubscriptionCase
  use SubscriptionCase

  setup [:setup_subscription]

  describe "add_item:constraints:single user" do
    test "should validate subscription presence", %{subscription: %{id: subscription_id}} do
      {:error,
       %{
         errors: [
           subscription:
             {_, [constraint: :assoc, constraint_name: "feed_items_subscription_id_fkey"]}
         ]
       }} =
        Feed.add_item(subscription_id + 1, "title", "content", "guid")
    end

    test "should create item", %{subscription: %{id: subscription_id}} do
      {:ok, _} = Feed.add_item(subscription_id, "title", "content", "guid")
    end

    test "should validate sub_id:guid pair uniqueness", %{subscription: %{id: subscription_id}} do
      {:ok, _} = Feed.add_item(subscription_id, "title", "content", "guid")
      {:ok, _} = Feed.add_item(subscription_id, "title", "content", "another-guid")

      {:error,
       %{
         errors: [
           subscription_id:
             {_, [constraint: :unique, constraint_name: "feed_items_guid_subscription_id_index"]}
         ]
       }} = Feed.add_item(subscription_id, "title", "content", "guid")
    end
  end

  describe "add_item:constraints:multiple users" do
    setup %{} do
      {:ok, account_2} = Accounts.create_account("username_2", pass_valid())
      {:ok, user_2} = Users.create_user(account_2.id)

      {:ok, subscription_2} =
        Subscriptions.create_subscription(user_2.id, "url", "tg_handle", "name")

      %{
        account_2: account_2,
        user_2: user_2,
        subscription_2: subscription_2
      }
    end

    test "should not fail when different users use same guid", %{
      subscription: subscription_1,
      subscription_2: subscription_2
    } do
      {:ok, _} = Feed.add_item(subscription_1.id, "title", "content", "guid")
      {:ok, _} = Feed.add_item(subscription_2.id, "title", "content", "guid")
    end
  end

  describe "get_items" do
    test "should return empty list for non-existing subscription", %{
      subscription: %{id: subscription_id}
    } do
      assert Feed.get_items(subscription_id + 1) == []
    end

    test "should return empty list when there is no items", %{
      subscription: %{id: subscription_id}
    } do
      assert Feed.get_items(subscription_id) == []
    end

    test "should return items ordered by creation datetime", %{
      subscription: %{id: subscription_id}
    } do
      {:ok, item_1} = Feed.add_item(subscription_id, "title", "content", "guid-1")
      {:ok, item_2} = Feed.add_item(subscription_id, "title", "content", "guid-2")
      assert Feed.get_items(subscription_id) == [item_2, item_1]
    end

    test "should only return 200 items", %{subscription: %{id: subscription_id}} do
      0..400
      |> Enum.each(fn x ->
        {:ok, _} = Feed.add_item(subscription_id, "title", "content", "guid-#{x}")
      end)

      result = Feed.get_items(subscription_id)
      assert length(result) == 200
    end
  end
end
