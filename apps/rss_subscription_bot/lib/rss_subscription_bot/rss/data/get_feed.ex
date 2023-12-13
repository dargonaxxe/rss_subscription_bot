defmodule RssSubscriptionBot.Rss.Data.GetFeed do
  alias RssSubscriptionBot.Rss.Domain.RssItem

  def get_feed(url) do
    with {:ok, response} <- request(url),
         {:ok, mapped_rss} <- FastRSS.parse_rss(response.body) do
      {:ok, mapped_rss |> Map.get("items")}
    else
      error -> error
    end
  end

  defp request(url) do
    Finch.build(:get, url)
    |> Finch.request(RssSubscriptionBot.Finch)
  end

  def to_domain(subscription_id, %{
        "title" => title,
        "content" => content,
        "guid" => %{"value" => guid}
      }) do
    %RssItem{
      subscription_id: subscription_id,
      title: title,
      content: content,
      guid: guid
    }
  end
end
