defmodule RssSubscriptionBot.Core.UserTest do
  use RssSubscriptionBot.SchemaCase

  alias RssSubscriptionBot.Core.User

  describe "fields & types" do
    @expected_fields_and_types [
      account_id: :id,
      id: :id,
      inserted_at: :naive_datetime,
      updated_at: :naive_datetime
    ]

    test "should have expected fields and types" do
      assert_has_fields(User, @expected_fields_and_types)
    end
  end
end
