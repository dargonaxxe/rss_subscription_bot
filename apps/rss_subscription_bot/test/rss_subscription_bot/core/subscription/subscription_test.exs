defmodule RssSubscriptionBot.Core.SubscriptionTest do
  alias RssSubscriptionBot.Core.Subscription
  use RssSubscriptionBot.SchemaCase

  defp create_subscription(_) do
    %{subscription: %Subscription{}}
  end

  describe "fields & types" do
    @expected_fields_and_types [
      id: :id,
      inserted_at: :naive_datetime,
      updated_at: :naive_datetime,
      url: :string,
      user_id: :id,
      tg_handle: :string,
      name: :string
    ]

    test "should have expected fields and types" do
      assert_has_fields(Subscription, @expected_fields_and_types)
    end
  end

  describe "new" do
    setup [:create_subscription]

    test "should return expected result", %{subscription: sub} do
      assert sub == Subscription.new()
    end
  end

  describe "changeset" do
    import RssSubscriptionBot.Subscription.Fixture

    test "should validate url presence" do
      %{errors: [url: {_, [validation: :required]}]} =
        Subscription.new() |> Subscription.changeset(attrs_no_url())
    end

    test "should validate user_id presence" do
      %{errors: [user_id: {_, [validation: :required]}]} =
        Subscription.new() |> Subscription.changeset(attrs_no_user_id())
    end

    test "should validate tg_handle presence" do
      %{errors: [tg_handle: {_, [validation: :required]}]} =
        Subscription.new() |> Subscription.changeset(attrs_no_tg_handle())
    end

    test "should return valid changeset" do
      %{valid?: true} = Subscription.new() |> Subscription.changeset(attrs_valid())
    end

    test "should validate name presence" do
      %{errors: [name: {_, [validation: :required]}]} =
        Subscription.new() |> Subscription.changeset(attrs_no_name())
    end
  end
end
