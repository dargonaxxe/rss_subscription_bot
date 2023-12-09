defmodule RssSubscriptionBot.Core.Session.RepoTest do
  alias RssSubscriptionBot.Core.Session
  use RssSubscriptionBot.AccountCase
  import Session.Fixture

  setup [:setup_account]

  describe "happy path" do
    test "should insert account without a problem", %{account: %{id: account_id}} do
      attrs = %{
        account_id: account_id,
        token: token(),
        valid_until: valid_until()
      }

      {:ok, _} =
        Session.new()
        |> Session.sign_in_changeset(attrs)
        |> Repo.insert()
    end
  end

  describe "constraints" do
    test "should validate account existance" do
      attrs = %{
        account_id: -1,
        token: token(),
        valid_until: valid_until()
      }

      {:error,
       %{
         errors: [account: {_, [constraint: :assoc, constraint_name: "sessions_account_id_fkey"]}]
       }} =
        Session.new()
        |> Session.sign_in_changeset(attrs)
        |> Repo.insert()
    end

    test "should validate valid_until date", %{account: %{id: account_id}} do
      attrs = %{
        account_id: account_id,
        token: token(),
        valid_until: ~N"2000-01-01 00:00:00"
      }

      {:error,
       %{
         errors: [
           valid_until:
             {_, [constraint: :check, constraint_name: "sessions_valid_until_constraint"]}
         ]
       }} =
        Session.new()
        |> Session.sign_in_changeset(attrs)
        |> Repo.insert()
    end
  end
end
