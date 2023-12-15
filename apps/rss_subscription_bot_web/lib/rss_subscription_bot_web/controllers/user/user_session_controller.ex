defmodule RssSubscriptionBotWeb.UserSessionController do
  alias RssSubscriptionBot.Core.Session
  alias RssSubscriptionBot.Core.Sessions
  use RssSubscriptionBotWeb, :controller

  def create(conn, %{"user" => user}) do
    %{"username" => username, "pwd_string" => pwd_string} = user

    username
    |> Sessions.sign_in(pwd_string)
    |> case do
      {:ok, %Session{token: token}} ->
        conn
        |> configure_session(renew: true)
        |> clear_session()
        |> put_session(:auth_token, token)
        |> put_session(:live_socket_id, "user_session:#{Base.url_encode64(token)}")
        |> redirect(to: ~p"/")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> put_flash(:username, username |> String.slice(0, 160))
        |> redirect(to: ~p"/user/login")
    end
  end
end
