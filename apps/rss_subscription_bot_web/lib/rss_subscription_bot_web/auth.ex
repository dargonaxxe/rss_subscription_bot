defmodule RssSubscriptionBotWeb.Auth do
  alias RssSubscriptionBot.Core.Account
  use RssSubscriptionBotWeb, :verified_routes
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
    token
    |> Sessions.get_account_by_token()
    |> case do
      nil ->
        conn

      %Account{} = account ->
        conn |> assign(:account, account)
    end
  end

  def redirect_if_authenticated(conn, _) do
    if conn.assigns[:account] do
      conn |> redirect(to: path_authenticated()) |> halt()
    else
      conn
    end
  end

  def require_authenticated(conn, _) do
    if conn.assigns[:account] do
      conn
    else
      conn |> redirect(to: path_unauthenticated()) |> halt()
    end
  end

  def on_mount(:require_authenticated, _params, session, socket) do
    socket = mount_account(socket, session)

    socket.assigns.account
    |> if do
      {:cont, socket}
    else
      {:halt, socket |> Phoenix.LiveView.redirect(to: path_unauthenticated())}
    end
  end

  defp mount_account(socket, session) do
    socket
    |> Phoenix.Component.assign_new(:account, fn ->
      session
      |> Map.get("auth_token")
      |> Sessions.get_account_by_token()
    end)
  end

  def path_authenticated() do
    ~p"/subscriptions"
  end

  def path_unauthenticated() do
    ~p"/user/login"
  end
end
