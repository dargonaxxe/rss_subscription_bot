defmodule RssSubscriptionBot.Subscription.Fixture do
  defp user_id, do: 1
  defp url, do: "url"
  defp tg_handle, do: "tg_handle"
  def attrs_no_url, do: %{user_id: user_id(), tg_handle: tg_handle()}
  def attrs_no_user_id, do: %{url: url(), tg_handle: tg_handle()}
  def attrs_no_tg_handle, do: %{url: url(), user_id: user_id()}
  def attrs_valid, do: %{user_id: user_id(), url: url(), tg_handle: tg_handle()}
end
