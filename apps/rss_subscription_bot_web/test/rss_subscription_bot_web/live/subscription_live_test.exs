defmodule RssSubscriptionBotWeb.SubscriptionLiveTest do
  # use RssSubscriptionBotWeb.ConnCase
  #
  # import Phoenix.LiveViewTest
  #
  # @create_attrs %{name: "some name", url: "some url", tg_handle: "some tg_handle"}
  # @update_attrs %{
  #   name: "some updated name",
  #   url: "some updated url",
  #   tg_handle: "some updated tg_handle"
  # }
  # @invalid_attrs %{name: nil, url: nil, tg_handle: nil}
  #
  # defp subscription_fixture do
  # end
  #
  # defp create_subscription(_) do
  #   subscription = subscription_fixture()
  #   %{subscription: subscription}
  # end
  #
  # describe "Index" do
  #   setup [:create_subscription]
  #
  #   test "lists all subscriptions", %{conn: conn, subscription: subscription} do
  #     {:ok, _index_live, html} = live(conn, ~p"/subscriptions")
  #
  #     assert html =~ "Listing Subscriptions"
  #     assert html =~ subscription.name
  #   end
  #
  #   test "saves new subscription", %{conn: conn} do
  #     {:ok, index_live, _html} = live(conn, ~p"/subscriptions")
  #
  #     assert index_live |> element("a", "New Subscription") |> render_click() =~
  #              "New Subscription"
  #
  #     assert_patch(index_live, ~p"/subscriptions/new")
  #
  #     assert index_live
  #            |> form("#subscription-form", subscription: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"
  #
  #     assert index_live
  #            |> form("#subscription-form", subscription: @create_attrs)
  #            |> render_submit()
  #
  #     assert_patch(index_live, ~p"/subscriptions")
  #
  #     html = render(index_live)
  #     assert html =~ "Subscription created successfully"
  #     assert html =~ "some name"
  #   end
  #
  #   test "updates subscription in listing", %{conn: conn, subscription: subscription} do
  #     {:ok, index_live, _html} = live(conn, ~p"/subscriptions")
  #
  #     assert index_live
  #            |> element("#subscriptions-#{subscription.id} a", "Edit")
  #            |> render_click() =~
  #              "Edit Subscription"
  #
  #     assert_patch(index_live, ~p"/subscriptions/#{subscription}/edit")
  #
  #     assert index_live
  #            |> form("#subscription-form", subscription: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"
  #
  #     assert index_live
  #            |> form("#subscription-form", subscription: @update_attrs)
  #            |> render_submit()
  #
  #     assert_patch(index_live, ~p"/subscriptions")
  #
  #     html = render(index_live)
  #     assert html =~ "Subscription updated successfully"
  #     assert html =~ "some updated name"
  #   end
  #
  #   test "deletes subscription in listing", %{conn: conn, subscription: subscription} do
  #     {:ok, index_live, _html} = live(conn, ~p"/subscriptions")
  #
  #     assert index_live
  #            |> element("#subscriptions-#{subscription.id} a", "Delete")
  #            |> render_click()
  #
  #     refute has_element?(index_live, "#subscriptions-#{subscription.id}")
  #   end
  # end
  #
  # describe "Show" do
  #   setup [:create_subscription]
  #
  #   test "displays subscription", %{conn: conn, subscription: subscription} do
  #     {:ok, _show_live, html} = live(conn, ~p"/subscriptions/#{subscription}")
  #
  #     assert html =~ "Show Subscription"
  #     assert html =~ subscription.name
  #   end
  #
  #   test "updates subscription within modal", %{conn: conn, subscription: subscription} do
  #     {:ok, show_live, _html} = live(conn, ~p"/subscriptions/#{subscription}")
  #
  #     assert show_live |> element("a", "Edit") |> render_click() =~
  #              "Edit Subscription"
  #
  #     assert_patch(show_live, ~p"/subscriptions/#{subscription}/show/edit")
  #
  #     assert show_live
  #            |> form("#subscription-form", subscription: @invalid_attrs)
  #            |> render_change() =~ "can&#39;t be blank"
  #
  #     assert show_live
  #            |> form("#subscription-form", subscription: @update_attrs)
  #            |> render_submit()
  #
  #     assert_patch(show_live, ~p"/subscriptions/#{subscription}")
  #
  #     html = render(show_live)
  #     assert html =~ "Subscription updated successfully"
  #     assert html =~ "some updated name"
  #   end
  # end
end
