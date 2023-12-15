defmodule RssSubscriptionBotWeb.Auth do
  use RssSubscriptionBotWeb, :verified_routes
  alias RssSubscriptionBot.Core.Accounts
  alias RssSubscriptionBot.Core.Sessions
  import Plug.Conn
  import Phoenix.Controller

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

  def redirect_if_authenticated(conn, _) do
    if conn.assigns[:account] do
      # todo: another path
      conn |> redirect(to: ~p"/") |> halt()
    else
      conn
    end
  end

  def require_authenticated(conn, _) do
    if conn.assigns[:account] do
      conn
    else
      conn |> redirect(to: ~p"/") |> halt()
    end
  end
end
