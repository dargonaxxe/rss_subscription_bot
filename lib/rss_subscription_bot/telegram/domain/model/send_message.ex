defmodule RssSubscriptionBot.Telegram.Domain.Model.SendMessage do
  defstruct [:chat_id, :text, :parse_mode, :disable_web_page_preview, :disable_notification]
end
