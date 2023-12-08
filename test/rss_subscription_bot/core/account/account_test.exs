defmodule RssSubscriptionBot.Core.AccountTest do
  use RssSubscriptionBot.SchemaCase
  alias RssSubscriptionBot.Core.Account

  defp create_account(_) do
    %{account: %Account{}}
  end

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

  describe "new()" do
    setup [:create_account]

    test "should return expected value", %{account: expected_value} do
      assert Account.new() == expected_value
    end
  end

  describe "registration changeset" do
    setup [:create_account]

    @pass_valid "passpasspass"
    @pass_invalid "passpass123"
    @username_valid "username"
    @username_invalid "12345"
    @attrs_username_absent %{pwd_string: @pass_valid}
    @attrs_pwd_string_absent %{username: @username_valid}
    @attrs_pass_invalid %{username: @username_valid, pwd_string: @pass_invalid}
    @attrs_username_invalid %{username: @username_invalid, pwd_string: @pass_valid}
    @attrs_valid %{username: @username_valid, pwd_string: @pass_valid}

    test "should validate username presence", %{account: account} do
      %{errors: [username: {_, [validation: :required]}]} =
        account
        |> Account.registration_changeset(@attrs_username_absent)
        |> assert_invalid()
    end

    test "should validate pwd_string presence", %{account: account} do
      %{errors: [pwd_string: {_, [validation: :required]}]} =
        account
        |> Account.registration_changeset(@attrs_pwd_string_absent)
        |> assert_invalid()
    end

    test "should validate pwd_string length", %{account: account} do
      %{errors: [pwd_string: {_, [count: 12, validation: :length, kind: :min, type: :string]}]} =
        account
        |> Account.registration_changeset(@attrs_pass_invalid)
        |> assert_invalid()
    end

    test "should validate username length", %{account: account} do
      %{errors: [username: {_, [count: 6, validation: :length, kind: :min, type: :string]}]} =
        account
        |> Account.registration_changeset(@attrs_username_invalid)
        |> assert_invalid()
    end

    test "should return valid changeset", %{account: account} do
      %{valid?: true} = account |> Account.registration_changeset(@attrs_valid)
    end
  end
end
