defmodule RssSubscriptionBot.Rss.Domain.RssItemTest do
  use ExUnit.Case

  alias RssSubscriptionBot.Telegram.Domain.Model.SendMessage
  alias RssSubscriptionBot.Rss.Domain.RssItem

  describe "to_send_message" do
    @title "title"
    @input %RssItem{
      title: @title,
      content: "line_1<br /><br />line_2",
      subscription_id: 1,
      guid: "guid"
    }
    @tg_user_id 2
    @expected_output %SendMessage{
      chat_id: @tg_user_id,
      text: "title\n\nline_1\n\nline_2",
      parse_mode: "html"
    }

    test "should return expected output" do
      assert @input |> RssItem.to_send_message(@tg_user_id) == @expected_output
    end
  end
end
