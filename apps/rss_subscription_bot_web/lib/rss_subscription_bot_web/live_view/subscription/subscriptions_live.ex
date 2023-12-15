defmodule RssSubscriptionBotWeb.SubscriptionsLive do
  use RssSubscriptionBotWeb, :live_view

  def mount(_, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello there</h1>
    """
  end
end
