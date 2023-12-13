defmodule RssSubscriptionBot.Telegram.PollingHandler do
  alias RssSubscriptionBot.Core.TgUsers
  use Telegex.Polling.GenHandler

  @impl true
  def on_boot() do
    {:ok, true} = Telegex.delete_webhook()
    %Telegex.Polling.Config{}
  end

  @impl true
  def on_update(%{message: %Telegex.Type.Message{} = message}) do
    message |> store()
  end

  @impl true
  def on_update(%Telegex.Type.Update{} = update) do
    IO.puts("not supported update type: #{inspect(update)}")
  end

  defp store(%{from: %{username: username, id: id}}) when username != nil and id != nil do
    id |> TgUsers.new_user(username)
  end

  defp store(_) do
    IO.puts("nothing to store")
  end
end
