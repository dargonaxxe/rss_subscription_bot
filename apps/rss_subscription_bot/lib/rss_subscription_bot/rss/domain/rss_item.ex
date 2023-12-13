defmodule RssSubscriptionBot.Rss.Domain.RssItem do
  alias RssSubscriptionBot.Telegram.Domain.Model.SendMessage
  defstruct [:subscription_id, :title, :content, :guid]

  def to_send_message(%__MODULE__{} = item, tg_user_id) do
    %SendMessage{chat_id: tg_user_id, text: item |> format_message(), parse_mode: "html"}
  end

  defp format_message(%__MODULE__{} = item) do
    "#{item.title}\n\n#{item.content |> clear_content()}"
  end

  defp clear_content(content) do
    content |> String.split("<br />") |> Enum.join("\n")
  end
end
