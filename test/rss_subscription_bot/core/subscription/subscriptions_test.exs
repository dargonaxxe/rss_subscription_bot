defmodule RssSubscriptionBot.Core.SubscriptionsTest do
  alias RssSubscriptionBot.Core.Subscriptions
  alias RssSubscriptionBot.UserCase
  alias RssSubscriptionBot.AccountCase
  use UserCase

  describe "create subscription" do
    setup [:setup_user]

    test "should fail when user does not exist", %{user: %{id: user_id}} do
      {:error,
       %{errors: [user: {_, [constraint: :assoc, constraint_name: "subscriptions_user_id_fkey"]}]}} =
        Subscriptions.create_subscription(user_id + 1, "url")
    end

    test "should successfully create subscription when user is present", %{user: %{id: user_id}} do
      {:ok, _} = Subscriptions.create_subscription(user_id, "url")
    end
  end
end
