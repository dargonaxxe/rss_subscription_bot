defmodule RssSubscriptionBot.Rss.Otp.UserObserver do
  alias RssSubscriptionBot.Rss.Otp.SubscriptionObserver
  alias RssSubscriptionBot.Core.Subscriptions
  use GenServer

  defstruct [:user_id, :subscriptions]

  def start_link(user_id) do
    name = {:via, Registry, {RssSubscriptionBot.Registry, {__MODULE__, user_id}}}
    GenServer.start_link(__MODULE__, user_id, name: name)
  end

  @impl GenServer
  def init(user_id) do
    {:ok, %__MODULE__{user_id: user_id}, {:continue, :get_subscriptions}}
  end

  @impl GenServer
  def handle_continue(:get_subscriptions, %{user_id: user_id} = state) do
    subscriptions = Subscriptions.get_subscriptions(user_id)

    {:noreply, put_in(state.subscriptions, subscriptions),
     {:continue, :wake_subscription_observers}}
  end

  @impl GenServer
  def handle_continue(:wake_subscription_observers, state) do
    state.subscriptions
    |> Enum.each(fn x ->
      {:ok, _} =
        {:via, Registry,
         {RssSubscriptionBot.Registry, {__MODULE__.DynamicSupervisor, state.user_id}}}
        |> DynamicSupervisor.start_child({SubscriptionObserver, x})
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:ping, state) do
    state.subscriptions
    |> Enum.each(fn x ->
      {:via, Registry, {RssSubscriptionBot.Registry, {SubscriptionObserver, x.id}}}
      |> GenServer.cast(:ping)
    end)

    {:noreply, state}
  end
end
