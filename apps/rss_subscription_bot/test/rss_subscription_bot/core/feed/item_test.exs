defmodule RssSubscriptionBot.Core.Feed.ItemTest do
  alias RssSubscriptionBot.Core.Feed.Item
  use RssSubscriptionBot.SchemaCase

  describe "fields & types" do
    @expected_fields_and_types [
      content: :string,
      id: :id,
      inserted_at: :naive_datetime,
      subscription_id: :id,
      title: :string,
      updated_at: :naive_datetime,
      guid: :string
    ]

    test "should have expected fields and types" do
      assert_has_fields(Item, @expected_fields_and_types)
    end
  end

  describe "new" do
    test "should return expected value" do
      assert Item.new() == %Item{}
    end
  end

  describe "changeset" do
    @subscription_id 1
    @title "title"
    @content "content"
    @guid "guid"
    @attrs_no_sub_id %{title: @title, content: @content, guid: @guid}
    @attrs_no_title %{subscription_id: @subscription_id, content: @content, guid: @guid}
    @attrs_no_content %{subscription_id: @subscription_id, title: @title, guid: @guid}
    @attrs_no_guid %{subscription_id: @subscription_id, title: @title, content: @content}
    @attrs_valid %{
      subscription_id: @subscription_id,
      title: @title,
      content: @content,
      guid: @guid
    }

    test "should validate sub_id presence" do
      %{errors: [subscription_id: {_, [validation: :required]}]} =
        Item.new() |> Item.changeset(@attrs_no_sub_id)
    end

    test "should validate title presence" do
      %{errors: [title: {_, [validation: :required]}]} =
        Item.new() |> Item.changeset(@attrs_no_title)
    end

    test "should validate content presence" do
      %{errors: [content: {_, [validation: :required]}]} =
        Item.new() |> Item.changeset(@attrs_no_content)
    end

    test "should validate guid presence" do
      %{errors: [guid: {_, [validation: :required]}]} =
        Item.new() |> Item.changeset(@attrs_no_guid)
    end

    test "should return valid changeset" do
      %{valid?: true} = Item.new() |> Item.changeset(@attrs_valid)
    end
  end

  describe "to_domain" do
    @subscription_id 1
    @title "title"
    @content "content"
    @guid "guid"
    @input %Item{
      subscription_id: @subscription_id,
      title: @title,
      content: @content,
      guid: @guid
    }
    alias RssSubscriptionBot.Rss.Domain.RssItem

    @expected_output %RssItem{
      subscription_id: @subscription_id,
      title: @title,
      content: @content,
      guid: @guid
    }
    test "should map as expected" do
      assert @input |> Item.to_domain() == @expected_output
    end
  end
end
