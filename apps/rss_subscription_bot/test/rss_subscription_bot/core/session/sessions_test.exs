defmodule RssSubscriptionBot.Core.SessionsTest do
  alias RssSubscriptionBot.Core.Sessions
  alias RssSubscriptionBot.AccountCase
  use AccountCase
  setup [:setup_account]

  describe "sign_in" do
    test "should sign in", %{account: %{username: username}} do
      {:ok, _} = Sessions.sign_in(username, pass_valid())
    end

    test "should fail with invalid username", %{account: %{username: username}} do
      {:error, :invalid_credentials} = (username <> "invalid") |> Sessions.sign_in(pass_valid())
    end

    test "should fail with invalid password", %{account: %{username: username}} do
      pass = pass_valid() <> "invalid"
      {:error, :invalid_credentials} = Sessions.sign_in(username, pass)
    end
  end

  describe "get_by_token" do
    test "should return session", %{account: %{username: username}} do
      {:ok, session_1} = Sessions.sign_in(username, pass_valid())

      session_2 = Sessions.get_by_token(session_1.token)
      assert session_1 == session_2
    end
  end

  describe "get_account_by_token" do
    test "should return account", %{account: %{username: username} = account_1} do
      keys_to_compare = [:username, :pwd_hash, :inserted_at, :updated_at]
      {:ok, session_1} = Sessions.sign_in(username, pass_valid())
      account_2 = Sessions.get_account_by_token(session_1.token)

      for key <- keys_to_compare do
        assert account_1 |> Map.get(key) == account_2 |> Map.get(key)
      end
    end
  end
end
