defmodule RssSubscriptionBot.Core.SubscriptionRepoTest do
  alias RssSubscriptionBot.UserCase
  alias RssSubscriptionBot.Core.Subscription
  use UserCase

  describe "constraints" do
    setup [:setup_user]
    import RssSubscriptionBot.Subscription.Fixture

    test "should fail with non-existent account", %{user: %{id: user_id}} do
      attrs = attrs_valid() |> Map.put(:user_id, user_id + 1)

      {:error,
       %{errors: [user: {_, [constraint: :assoc, constraint_name: "subscriptions_user_id_fkey"]}]}} =
        Subscription.new()
        |> Subscription.changeset(attrs)
        |> Repo.insert()
    end

    test "should return {:ok, _} tuple", %{user: %{id: user_id}} do
      attrs = attrs_valid() |> Map.put(:user_id, user_id)
      {:ok, _} = Subscription.new() |> Subscription.changeset(attrs) |> Repo.insert()
    end
  end
end
