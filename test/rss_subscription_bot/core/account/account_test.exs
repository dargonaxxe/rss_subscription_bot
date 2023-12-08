defmodule RssSubscriptionBot.Core.AccountTest do
  use ExUnit.Case
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
      actual_fields_and_types =
        for field <- Account.__schema__(:fields), do: {field, Account.__schema__(:type, field)}

      assert MapSet.new(actual_fields_and_types) == MapSet.new(@expected_fields_and_types)
    end
  end
end
