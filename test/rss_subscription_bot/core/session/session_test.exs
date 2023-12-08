defmodule RssSubscriptionBot.Core.SessionTest do
  alias RssSubscriptionBot.Core.Session
  alias RssSubscriptionBot.SchemaCase
  use SchemaCase

  describe "fields & types" do
    @expected_fields_and_types [
      account_id: :id,
      id: :id,
      inserted_at: :naive_datetime,
      token: :binary,
      updated_at: :naive_datetime,
      valid_until: :naive_datetime
    ]

    test "should have expected fields and types" do
      assert_has_fields(Session, @expected_fields_and_types)
    end
  end
end
