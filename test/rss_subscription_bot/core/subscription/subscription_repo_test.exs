defmodule RssSubscriptionBot.Core.SubscriptionRepoTest do
  alias RssSubscriptionBot.Core.Subscription
  alias RssSubscriptionBot.AccountCase
  use AccountCase

  describe "constraints" do
    setup [:setup_account]
    import RssSubscriptionBot.Subscription.Fixture

    test "should fail with non-existent account", %{account: %{id: account_id}} do
      attrs = attrs_valid() |> Map.put(:account_id, account_id + 1)

      {:error,
       %{errors: [user: {_, [constraint: :assoc, constraint_name: "subscriptions_user_id_fkey"]}]}} =
        Subscription.new()
        |> Subscription.changeset(attrs)
        |> Repo.insert()
    end
  end
end
