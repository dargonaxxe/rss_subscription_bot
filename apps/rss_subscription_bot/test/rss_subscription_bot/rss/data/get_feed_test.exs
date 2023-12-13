defmodule RssSubscriptionBot.Rss.Data.GetFeedTest do
  use ExUnit.Case

  describe "get_feed" do
    import Mock

    setup %{} do
      {:ok, content} =
        Path.expand("../../../res/rss_output", __DIR__)
        |> File.read()

      response = %Finch.Response{
        status: 200,
        body: content
      }

      %{response: response}
    end

    @url "url"
    @expected_result [
      %{
        "author" => nil,
        "categories" => [],
        "comments" => nil,
        "content" => "description-1",
        "description" => "description-1",
        "dublin_core_ext" => nil,
        "enclosure" => nil,
        "extensions" => %{},
        "guid" => %{"permalink" => true, "value" => "guid-1"},
        "itunes_ext" => nil,
        "link" => "link-1",
        "pub_date" => "Fri, 08 Dec 2023 04:47:44 +0000",
        "source" => nil,
        "title" => "title-1"
      },
      %{
        "author" => nil,
        "categories" => [],
        "comments" => nil,
        "content" => "description-2",
        "description" => "description-2",
        "dublin_core_ext" => nil,
        "enclosure" => nil,
        "extensions" => %{},
        "guid" => %{"permalink" => true, "value" => "guid-2"},
        "itunes_ext" => nil,
        "link" => "link-2",
        "pub_date" => "Fri, 08 Dec 2023 04:47:42 +0000",
        "source" => nil,
        "title" => "title-2"
      }
    ]

    test "should return expected result", %{response: response} do
      with_mock(Finch,
        request: fn :request, RssSubscriptionBot.Finch -> {:ok, response} end,
        build: fn :get, @url -> :request end
      ) do
        assert RssSubscriptionBot.Rss.Data.GetFeed.get_feed(@url) == {:ok, @expected_result}
      end
    end
  end

  describe "to_domain" do
    @subscription_id 1
    @title "title"
    @content "content"
    @guid "guid"
    @input %{
      "title" => @title,
      "content" => @content,
      "guid" => %{"permalink" => true, "value" => @guid}
    }
    alias RssSubscriptionBot.Rss.Data.GetFeed
    alias RssSubscriptionBot.Rss.Domain.RssItem

    @expected_output %RssItem{
      title: @title,
      content: @content,
      guid: @guid,
      subscription_id: @subscription_id
    }
    test "should map as expected" do
      assert GetFeed.to_domain(@subscription_id, @input) == @expected_output
    end
  end
end
