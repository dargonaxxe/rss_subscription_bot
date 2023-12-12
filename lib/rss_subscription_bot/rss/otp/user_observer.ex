defmodule RssSubscriptionBot.Rss.Otp.UserObserver do
  alias RssSubscriptionBot.Rss.Otp.SubscriptionObserver
  alias RssSubscriptionBot.Core.Subscriptions
  use GenServer

  defstruct [:user_id, :subscriptions]

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
        |> DynamicSupervisor.start_child(x |> child_key())
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:ping, state) do
    state.subscriptions
    |> Enum.each(fn x ->
      x.id
      |> child_key()
      |> via()
      |> GenServer.cast(:ping)
    end)

    {:noreply, state}
  end

  defp module_key(id) do
    {__MODULE__, id}
  end

  defp supervisor_key(id) do
    {__MODULE__.DynamicSupervisor, id}
  end

  defp child_key(id) do
    {SubscriptionObserver, id}
  end

  defp via(key) do
    {:via, Registry, {RssSubscriptionBot.Registry, key}}
  end
end
