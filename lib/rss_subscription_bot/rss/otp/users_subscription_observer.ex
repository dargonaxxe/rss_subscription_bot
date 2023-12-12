defmodule RssSubscriptionBot.Rss.Otp.UsersSubscriptionObserver do
  alias RssSubscriptionBot.Rss.Otp.UserObserver
  alias RssSubscriptionBot.Core.Users
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl GenServer
  def init(_) do
    {:ok, nil, {:continue, :get_users}}
  end

  @impl GenServer
  def handle_continue(:get_users, _) do
    users = Users.get_users()
    {:ok, _} = :timer.send_interval(1000, self(), :ping)
    {:noreply, users, {:continue, :init_user_observers}}
  end

  def handle_continue(:init_user_observers, state) do
    state
    |> Enum.each(fn %{id: id} ->
      {:ok, _} =
        RssSubscriptionBot.UsersDynamicSupervisor
        |> DynamicSupervisor.start_child({UserObserver, id})
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:ping, state) do
    state
    |> Enum.each(fn %{id: id} ->
      {:via, Registry, {RssSubscriptionBot.Registry, {UserObserver, id}}} |> GenServer.cast(:ping)
    end)

    {:noreply, state}
  end
end
