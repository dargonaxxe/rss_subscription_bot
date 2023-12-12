defmodule RssSubscriptionBot.Rss.Otp.UsersSubscriptionObserver do
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
    {:noreply, users}
  end

  @impl GenServer
  def handle_info(:ping, state) do
    IO.puts("pong")
    {:noreply, state}
  end
end
