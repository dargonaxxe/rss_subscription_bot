defmodule RssSubscriptionBot.Rss.Data.GetFeed do
  def get_feed(url) do
    with {:ok, response} <- request(url),
         {:ok, mapped_rss} <- FastRSS.parse_rss(response.body) do
      mapped_rss |> Map.get("items")
    else
      error -> error
    end
  end

  defp request(url) do
    Finch.build(:get, url)
    |> Finch.request(RssSubscriptionBot.Finch)
  end
end
