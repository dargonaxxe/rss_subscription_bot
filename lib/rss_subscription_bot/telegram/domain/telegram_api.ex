defmodule RssSubscriptionBot.Telegram.Domain.TelegramApi do
  use GenServer

  defstruct queue: [], send_timestamps: []

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    {:ok, %__MODULE__{}}
  end
end
