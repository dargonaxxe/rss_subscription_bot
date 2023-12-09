defmodule RssSubscriptionBot.Core.SessionsTest do
  alias RssSubscriptionBot.Core.Sessions
  alias RssSubscriptionBot.AccountCase
  use AccountCase
  setup [:setup_account]

  describe "sign_in" do
    test "should sign in", %{account: %{username: username}} do
      {:ok, session} = Sessions.sign_in(username, pass_valid())
    end

    test "should fail with invalid username", %{account: %{username: username}} do
      {:error, :invalid_credentials} = (username <> "invalid") |> Sessions.sign_in(pass_valid())
    end

    test "should fail with invalid password", %{account: %{username: username}} do
      pass = pass_valid() <> "invalid"
      {:error, :invalid_credentials} = Sessions.sign_in(username, pass)
    end
  end
end
