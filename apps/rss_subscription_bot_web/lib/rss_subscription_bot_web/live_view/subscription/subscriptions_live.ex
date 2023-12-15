defmodule RssSubscriptionBotWeb.SubscriptionsLive do
  alias RssSubscriptionBot.Core.Subscriptions
  alias RssSubscriptionBot.Core.Users
  use RssSubscriptionBotWeb, :live_view

  def mount(_, _session, socket) do
    subs =
      socket.assigns
      |> Map.get(:account)
      |> Map.get(:id)
      |> Users.get_user_by_account_id()
      |> Map.get(:id)
      |> Subscriptions.get_subscriptions()

    {:ok, socket |> stream(:subscriptions, subs)}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello there</h1>
    <.table rows={@streams.subscriptions} id="subscriptions"> 
      <:col :let={{_id, subscription}} label="Telegram handle"><%= subscription.tg_handle %> </:col>
      <:col :let={{_id, subscription}} label="Url"><%= subscription.url %> </:col>
    </.table>
    """
  end
end
