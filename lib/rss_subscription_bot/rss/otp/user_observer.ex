defmodule RssSubscriptionBot.Rss.Otp.UserObserver do
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
    {:noreply, put_in(state.subscriptions, subscriptions)}
  end

  @impl GenServer
  def handle_cast(:ping, state) do
    IO.puts("pong")
    {:noreply, state}
  end
end
