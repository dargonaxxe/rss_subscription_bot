defmodule RssSubscriptionBot.Core.TgUserTest do
  alias RssSubscriptionBot.Core.TgUser
  alias RssSubscriptionBot.SchemaCase
  use SchemaCase

  describe "fields & types" do
    @expected_fields_and_types [
      handle: :string,
      inserted_at: :naive_datetime,
      tg_id: :id,
      updated_at: :naive_datetime
    ]

    test "should have expected fields and types" do
      assert_has_fields(TgUser, @expected_fields_and_types)
    end
  end

  describe "new" do
    test "should return expected result" do
      assert TgUser.new() == %TgUser{}
    end
  end

  describe "changeset" do
    @tg_id 1
    @handle "handle"
    @attrs_no_tg_id %{handle: @handle}
    @attrs_no_handle %{tg_id: @tg_id}
    @attrs_valid %{tg_id: @tg_id, handle: @handle}

    test "should validate tg_id presence" do
      %{errors: [tg_id: {_, [validation: :required]}]} =
        TgUser.new() |> TgUser.changeset(@attrs_no_tg_id)
    end

    test "should validate handle presence" do
      %{errors: [handle: {_, [validation: :required]}]} =
        TgUser.new() |> TgUser.changeset(@attrs_no_handle)
    end

    test "should return valid changeset" do
      %{valid?: true} = TgUser.new() |> TgUser.changeset(@attrs_valid)
    end
  end
end
