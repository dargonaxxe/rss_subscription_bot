defmodule RssSubscriptionBotWeb.UserSessionController do
  use RssSubscriptionBotWeb, :controller

  def create(conn, params) do
    params |> inspect() |> IO.puts()

    conn
  end
end
