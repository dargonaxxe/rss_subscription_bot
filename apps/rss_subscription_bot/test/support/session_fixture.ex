defmodule RssSubscriptionBot.Core.Session.Fixture do
  alias RssSubscriptionBot.Core.Session
  def account_id, do: 1
  def token(), do: "12345678123456781234567812345678"
  def valid_until(), do: ~N"2024-01-01 23:00:00"
  def attrs_no_account_id(), do: %{token: token(), valid_until: valid_until()}
  def attrs_no_token(), do: %{account_id: account_id(), valid_until: valid_until()}
  def attrs_no_valid_until(), do: %{account_id: account_id(), token: token()}
  def attrs_valid(), do: %{account_id: account_id(), token: token(), valid_until: valid_until()}

  def create_session(_) do
    %{session: %Session{}}
  end
end
