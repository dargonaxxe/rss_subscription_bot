defmodule RssSubscriptionBot.Core.User.Fixture do
  defp account_id(), do: 1
  def attrs_invalid(), do: %{}
  def attrs_valid(), do: %{account_id: account_id()}
end
