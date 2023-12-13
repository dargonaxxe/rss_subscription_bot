defmodule RssSubscriptionBot.Core.UserTest do
  use RssSubscriptionBot.SchemaCase

  alias RssSubscriptionBot.Core.User

  defp create_user(_) do
    %{user: %User{}}
  end

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

  describe "new" do
    setup [:create_user]

    test "should return expected result", %{user: user} do
      assert user == User.new()
    end
  end

  describe "changeset" do
    import User.Fixture

    test "should validate account_id presence" do
      %{errors: [account_id: {_, [validation: :required]}]} =
        User.new() |> User.changeset(attrs_invalid())
    end

    test "should return valid changeset" do
      %{valid?: true} = User.new() |> User.changeset(attrs_valid())
    end
  end
end
