defmodule RssSubscriptionBot.Telegram.Domain.TelegramApi do
  alias RssSubscriptionBot.Telegram.Domain.Model.SendMessage
  use GenServer

  defstruct queue: [], send_timestamps: []

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def send_message(%SendMessage{} = message) do
    GenServer.call(__MODULE__, {:send_message, message})
  end

  def ping() do
    GenServer.whereis(__MODULE__)
    |> send(:ping)
  end

  @throughput 20
  @interval 1000 / @throughput
  @impl GenServer
  def init(_) do
    :timer.send_interval(@interval, self(), :ping)
    {:ok, %__MODULE__{}}
  end

  @impl GenServer
  def handle_call({:send_message, message}, _from, state) do
    state = state |> add_to_queue(message)
    ping()
    {:reply, :ok, state}
  end

  defp add_to_queue(state, event) do
    queue = state.queue ++ [event]
    put_in(state.queue, queue)
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

  defp process_queue_item(%SendMessage{} = item) do
    Telegex.send_message(item.chat_id, item.text, parse_mode: item.parse_mode)
    |> case do
      {:ok, _} ->
        :ok

      error ->
        error |> inspect() |> IO.puts()
        error
    end
  end

  defp process_queue_item(item) do
    IO.puts("unknown type: #{inspect(item)}")
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
