defmodule RssSubscriptionBot.Core.TgUserTest do
  alias RssSubscriptionBot.Core.TgUser
  alias RssSubscriptionBot.SchemaCase
  use SchemaCase

  describe "fields & types" do
    @expected_fields_and_types [
      handle: :string,
      id: :id,
      inserted_at: :naive_datetime,
      tg_id: :id,
      updated_at: :naive_datetime
    ]

    test "should have expected fields and types" do
      assert_has_fields(TgUser, @expected_fields_and_types)
    end
  end
end
