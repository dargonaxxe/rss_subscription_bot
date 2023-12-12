defmodule RssSubscriptionBot.Rss.Otp.SubscriptionObserver do
  alias RssSubscriptionBot.Core.Feed.Item
  alias RssSubscriptionBot.Core.Feed
  use GenServer

  defstruct [:subscription, :fetched_items, :last_fetched_datetime]

  def ping(id) do
    id |> module_key() |> via |> GenServer.cast(:ping)
  end

  def start_link(subscription) do
    name = {:via, Registry, {RssSubscriptionBot.Registry, {__MODULE__, subscription.id}}}
    GenServer.start_link(__MODULE__, subscription, name: name)
  end

  @impl GenServer
  def init(subscription) do
    {:ok, %__MODULE__{subscription: subscription}, {:continue, :get_items}}
  end

  @impl GenServer
  def handle_continue(:get_items, %{subscription: %{id: sub_id}} = state) do
    items =
      Feed.get_items(sub_id)
      |> Enum.map(&Item.to_domain/1)

    {:noreply, put_in(state.fetched_items, items)}
  end

  @impl GenServer
  def handle_cast(:ping, %{last_fetched_datetime: nil} = state) do
    {:noreply, fetch(state)}
  end

  @impl GenServer
  def handle_cast(:ping, %{} = state) do
    delta =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.diff(state.last_fetched_datetime)

    state =
      if delta >= 15 do
        fetch(state)
      else
        state
      end

    {:noreply, state}
  end

  defp fetch(state) do
    IO.puts("fetching...")
    put_in(state.last_fetched_datetime, NaiveDateTime.utc_now())
  end

  def module_key(id) do
    {__MODULE__, id}
  end

  defp via(key) do
    {:via, Registry, {RssSubscriptionBot.Registry, key}}
  end
end
