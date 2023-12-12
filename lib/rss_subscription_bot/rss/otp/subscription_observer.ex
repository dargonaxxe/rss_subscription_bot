defmodule RssSubscriptionBot.Rss.Otp.SubscriptionObserver do
  alias RssSubscriptionBot.Rss.Data.GetFeed
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
    {:ok, feed} =
      state.subscription.url
      |> GetFeed.get_feed()

    new_items =
      feed
      |> Enum.map(fn x -> GetFeed.to_domain(state.subscription.id, x) end)
      |> MapSet.new()
      |> MapSet.difference(state.fetched_items |> MapSet.new())
      |> MapSet.to_list()

    store_updates(state.subscription.id, new_items)

    state = put_in(state.fetched_items, new_items ++ state.fetched_items)
    put_in(state.last_fetched_datetime, NaiveDateTime.utc_now())
  end

  defp store_updates(subscription_id, updates) do
    updates
    |> Enum.each(fn x ->
      Feed.add_item(subscription_id, x.title, x.content, x.guid)
    end)
  end

  def module_key(id) do
    {__MODULE__, id}
  end

  defp via(key) do
    {:via, Registry, {RssSubscriptionBot.Registry, key}}
  end
end
