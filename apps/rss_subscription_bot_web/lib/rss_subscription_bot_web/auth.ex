defmodule RssSubscriptionBotWeb.Auth do
  alias RssSubscriptionBot.Core.Accounts
  alias RssSubscriptionBot.Core.Sessions
  import Plug.Conn

  def put_account(conn, _opts) do
    conn
    |> get_session(:auth_token)
    |> case do
      nil ->
        conn

      token ->
        conn |> assign_account(token)
    end
  end

  defp assign_account(conn, token) do
    with %{account_id: account_id} <- Sessions.get_by_token(token),
         %{} = account <- Accounts.get_account_by_id(account_id) do
      conn |> assign(:account, account)
    else
      _ ->
        conn
    end
  end
end
