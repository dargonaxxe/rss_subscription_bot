defmodule RssSubscriptionBot.Rss.Otp.UserObserver do
  alias RssSubscriptionBot.Rss.Otp.SubscriptionObserver
  alias RssSubscriptionBot.Core.Subscriptions
  use GenServer

  defstruct [:user_id, :subscriptions]

  def add(subscription) do
    subscription.user_id |> module_key() |> via() |> GenServer.call({:add, subscription})
  end

  def delete(user_id, subscription_id) do
    user_id |> module_key() |> via() |> GenServer.call({:delete, subscription_id})
  end

  def ping(id) do
    id |> module_key() |> via() |> GenServer.cast(:ping)
  end

  def start_link(user_id) do
    name =
      user_id
      |> module_key()
      |> via()

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
        state.user_id
        |> supervisor_key()
        |> via()
        |> DynamicSupervisor.start_child({SubscriptionObserver, x})
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:ping, state) do
    state.subscriptions
    |> Enum.each(fn x ->
      SubscriptionObserver.ping(x.id)
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:delete, subscription_id}, _from, state) do
    :ok =
      state.subscriptions
      |> Enum.find(fn x -> x.id == subscription_id end)
      |> case do
        nil ->
          :ok

        %{} ->
          [{pid, _}] =
            RssSubscriptionBot.Registry
            |> Registry.lookup(subscription_id |> SubscriptionObserver.module_key())

          state.user_id
          |> supervisor_key()
          |> via()
          |> DynamicSupervisor.terminate_child(pid)
      end

    updated_list = state.subscriptions |> Enum.filter(fn x -> x.id != subscription_id end)
    {:reply, :ok, put_in(state.subscriptions, updated_list)}
  end

  def handle_call({:add, subscription}, _from, state) do
    {:ok, _} =
      state.user_id
      |> supervisor_key()
      |> via()
      |> DynamicSupervisor.start_child(SubscriptionObserver.module_key(subscription))

    {:reply, :ok, put_in(state.subscriptions, [subscription | state.subscriptions])}
  end

  defp module_key(id) do
    id |> key(__MODULE__)
  end

  defp supervisor_key(id) do
    id |> key(__MODULE__.DynamicSupervisor)
  end

  defp key(id, module) do
    {module, id}
  end

  defp via(key) do
    {:via, Registry, {RssSubscriptionBot.Registry, key}}
  end
end
