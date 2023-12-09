defmodule RssSubscriptionBot.Subscription.Fixture do
  defp user_id, do: 1
  defp url, do: "url"
  def attrs_no_url, do: %{user_id: user_id()}
  def attrs_no_user_id, do: %{url: url()}
  def attrs_valid, do: %{user_id: user_id(), url: url()}
end
