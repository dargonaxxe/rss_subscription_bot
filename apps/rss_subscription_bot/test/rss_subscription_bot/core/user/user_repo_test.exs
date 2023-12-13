defmodule RssSubscriptionBot.Core.UserRepoTest do
  alias RssSubscriptionBot.Core.User
  alias RssSubscriptionBot.AccountCase
  use AccountCase

  describe "constraints" do
    import User.Fixture
    setup [:setup_account]

    test "should fail without existing account", %{account: %{id: account_id}} do
      attrs = attrs_valid() |> Map.put(:account_id, account_id + 1)

      {:error,
       %{errors: [account: {_, [constraint: :assoc, constraint_name: "users_account_id_fkey"]}]}} =
        User.new() |> User.changeset(attrs) |> Repo.insert()
    end

    test "should successfully create a user", %{account: %{id: account_id}} do
      attrs = attrs_valid() |> Map.put(:account_id, account_id)
      {:ok, _} = User.new() |> User.changeset(attrs) |> Repo.insert()
    end
  end
end
