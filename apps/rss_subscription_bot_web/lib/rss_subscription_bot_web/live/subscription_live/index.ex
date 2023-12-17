defmodule RssSubscriptionBotWeb.SubscriptionLive.Index do
  alias RssSubscriptionBot.Rss.Otp.UserObserver
  alias RssSubscriptionBot.Core.Subscription
  alias RssSubscriptionBot.Core.Subscriptions
  alias RssSubscriptionBot.Core.Users
  alias RssSubscriptionBot.Core.Sessions
  use RssSubscriptionBotWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    subscriptions =
      session
      |> Map.get("auth_token")
      |> Sessions.get_account_by_token()
      |> Map.get(:id)
      |> Users.get_user_by_account_id()
      |> Map.get(:id)
      |> Subscriptions.get_subscriptions()

    socket.assigns |> inspect() |> IO.puts()

    {:ok, stream(socket, :subscriptions, subscriptions)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Subscription")
    |> assign(:subscription, Subscriptions.get_subscription!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Subscription")
    |> assign(:subscription, %Subscription{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Subscriptions")
    |> assign(:subscription, nil)
  end

  @impl true
  def handle_info(
        {RssSubscriptionBotWeb.SubscriptionLive.FormComponent, {:saved, subscription}},
        socket
      ) do
    {:noreply, stream_insert(socket, :subscriptions, subscription)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subscription = Subscriptions.get_subscription!(id)
    UserObserver.delete(subscription.user_id, subscription.id)
    {:ok, _} = Subscriptions.delete_subscription(subscription)

    {:noreply, stream_delete(socket, :subscriptions, subscription)}
  end
end
