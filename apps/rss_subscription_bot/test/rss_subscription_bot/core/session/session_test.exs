defmodule RssSubscriptionBot.Core.SessionTest do
  alias RssSubscriptionBot.Core.Session
  alias RssSubscriptionBot.SchemaCase
  use SchemaCase
  import RssSubscriptionBot.Core.Session.Fixture

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

  describe "new()" do
    setup [:create_session]

    test "should return expected result", %{session: session} do
      assert Session.new() == session
    end
  end

  describe "sign_in_changeset" do
    setup [:create_session]

    test "should validate account_id presence", %{session: session} do
      %{errors: [account_id: {_, [validation: :required]}]} =
        session |> Session.sign_in_changeset(attrs_no_account_id())
    end

    test "should validate token presence", %{session: session} do
      %{errors: [token: {_, [validation: :required]}]} =
        session |> Session.sign_in_changeset(attrs_no_token())
    end

    test "should validate valid_until presence", %{session: session} do
      %{errors: [valid_until: {_, [validation: :required]}]} =
        session |> Session.sign_in_changeset(attrs_no_valid_until())
    end

    test "should return no errors", %{session: session} do
      %{valid?: true} = session |> Session.sign_in_changeset(attrs_valid())
    end
  end
end
