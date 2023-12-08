defmodule RssSubscriptionBot.Core.SubscriptionTest do
  alias RssSubscriptionBot.Core.Subscription
  use RssSubscriptionBot.SchemaCase

  describe "fields & types" do
    @expected_fields_and_types [
      id: :id,
      inserted_at: :naive_datetime,
      updated_at: :naive_datetime,
      url: :string,
      user_id: :id
    ]

    test "should have expected fields and types" do
      assert_has_fields(Subscription, @expected_fields_and_types)
    end
  end
end
