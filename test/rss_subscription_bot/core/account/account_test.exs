defmodule RssSubscriptionBot.Core.AccountTest do
  use RssSubscriptionBot.SchemaCase
  alias RssSubscriptionBot.Core.Account

  describe "fields & types" do
    @expected_fields_and_types [
      id: :id,
      username: :string,
      pwd_hash: :binary,
      inserted_at: :naive_datetime,
      updated_at: :naive_datetime
    ]
    test "should have expected fields and types" do
      assert_has_fields(Account, @expected_fields_and_types)
    end
  end
end
