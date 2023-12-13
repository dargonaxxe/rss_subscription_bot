defmodule RssSubscriptionBot.Telegram.Domain.TelegramApi do
  use GenServer

  defstruct queue: [], send_timestamps: []

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @throughput 20
  @interval 1000 / @throughput
  @impl GenServer
  def init(_) do
    :timer.send_interval(@interval, self(), :ping)
    {:ok, %__MODULE__{}}
  end

  @impl GenServer
  def handle_info(:ping, %{queue: []} = state) do
    IO.puts("nothing to take care of")
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:ping, state) do
    state =
      state
      |> update_state()
      |> process_state()

    {:noreply, state}
  end

  defp process_state(state) do
    state.queue
    |> length
    |> Kernel.>(20)
    |> if do
      state
    else
      state |> process_queue()
    end
  end

  defp process_queue(state) do
    [head | tail] = state.queue

    head
    |> process_queue_item()
    |> case do
      :ok ->
        now = NaiveDateTime.utc_now()
        state = put_in(state.queue, tail)
        put_in(state.send_timestamps, [now | state.send_timestamps])

      _ ->
        state
    end
  end

  defp process_queue_item(_item) do
    IO.puts("ping")
  end

  defp update_state(%{send_timestamps: timestamps} = state) do
    timestamps = timestamps |> Enum.filter(&within_second?/1)
    put_in(state.send_timestamps, timestamps)
  end

  defp within_second?(datetime) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.diff(datetime, :millisecond)
    |> Kernel.>(1000)
  end
end
