defmodule RssSubscriptionBot.Rss.Otp.UsersSubscriptionObserver do
  alias RssSubscriptionBot.Core.User
  alias RssSubscriptionBot.Rss.Otp.UserObserver
  alias RssSubscriptionBot.Core.Users
  use GenServer
  @registry RssSubscriptionBot.Registry

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def delete(user_id) do
    GenServer.call(__MODULE__, {:delete, user_id})
  end

  def add(%User{} = user) do
    GenServer.call(__MODULE__, {:add, user})
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

  @root_dynamic_supervisor RssSubscriptionBot.UsersDynamicSupervisor
  def handle_continue(:init_user_observers, state) do
    state
    |> Enum.each(fn %{id: id} -> start_user_observer(id) end)

    {:noreply, state}
  end

  # todo: handle less happy paths 
  defp start_user_observer(id) do
    {:ok, pid} =
      @root_dynamic_supervisor
      |> DynamicSupervisor.start_child(id |> dynamic_supervisor_child_spec())

    {:ok, _} =
      pid
      |> DynamicSupervisor.start_child({UserObserver, id})
  end

  defp dynamic_supervisor_child_spec(id) do
    {DynamicSupervisor, strategy: :one_for_one, name: id |> child_supervisor_key() |> via()}
  end

  @impl GenServer
  def handle_info(:ping, state) do
    state
    |> Enum.each(fn %{id: id} ->
      UserObserver.ping(id)
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:delete, user_id}, _, state) do
    :ok =
      state
      |> Enum.find(fn x -> x.id == user_id end)
      |> case do
        %{} ->
          [{pid, _}] = @registry |> Registry.lookup(user_id |> child_supervisor_key())

          @root_dynamic_supervisor |> DynamicSupervisor.terminate_child(pid)

        nil ->
          :ok
      end

    {:reply, :ok, state |> Enum.filter(fn x -> x.id != user_id end)}
  end

  @impl GenServer
  def handle_call({:add, %User{} = user}, _from, state) do
    # todo: validate list state
    start_user_observer(user.id)
    {:reply, :ok, [user | state]}
  end

  defp child_supervisor_key(id), do: {UserObserver.DynamicSupervisor, id}

  defp via(key) do
    {:via, Registry, {RssSubscriptionBot.Registry, key}}
  end
end
