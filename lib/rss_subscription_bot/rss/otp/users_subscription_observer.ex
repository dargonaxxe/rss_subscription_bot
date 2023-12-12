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
        |> DynamicSupervisor.start_child(id |> child_key())

      {:ok, _} =
        DynamicSupervisor.start_link(
          strategy: :one_for_one,
          name: {:via, Registry, {RssSubscriptionBot.Registry, id |> child_supervisor_key()}}
        )
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:ping, state) do
    state
    |> Enum.each(fn %{id: id} ->
      {:via, Registry, {RssSubscriptionBot.Registry, id |> child_key()}} |> GenServer.cast(:ping)
    end)

    {:noreply, state}
  end

  defp child_key(id), do: {UserObserver, id}
  defp child_supervisor_key(id), do: {UserObserver.DynamicSupervisor, id}
end
