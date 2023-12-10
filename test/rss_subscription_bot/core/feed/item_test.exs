defmodule RssSubscriptionBot.Core.Feed.ItemTest do
  alias RssSubscriptionBot.Core.Feed.Item
  use RssSubscriptionBot.SchemaCase

  describe "fields & types" do
    @expected_fields_and_types [
      content: :string,
      id: :id,
      inserted_at: :naive_datetime,
      subscription_id: :id,
      title: :string,
      updated_at: :naive_datetime,
      guid: :string
    ]

    test "should have expected fields and types" do
      assert_has_fields(Item, @expected_fields_and_types)
    end
  end
end
