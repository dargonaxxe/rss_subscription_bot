defmodule RssSubscriptionBot.Core.Sessions do
  alias RssSubscriptionBot.Core.Accounts
  alias RssSubscriptionBot.Core.Session
  alias RssSubscriptionBot.Core.Account
  alias RssSubscriptionBot.Repo

  import Ecto.Query

  def sign_in(username, pwd_string) do
    username
    |> get_account_query()
    |> Repo.one()
    |> verify_pass(pwd_string)
    |> create_session()
  end

  defp get_account_query(username) do
    from(u in Account, where: u.username == ^username)
  end

  defp verify_pass(nil, _pwd_string), do: {Bcrypt.no_user_verify(), nil}

  defp verify_pass(%{pwd_hash: pwd_hash, id: account_id}, pwd_string) do
    {Bcrypt.verify_pass(pwd_string, pwd_hash), account_id}
  end

  defp create_session({false, _}), do: {:error, :invalid_credentials}
  # todo: move to config 
  @token_bytes_length 32
  defp create_session({true, account_id}) do
    attrs = %{
      account_id: account_id,
      token: :crypto.strong_rand_bytes(@token_bytes_length),
      valid_until: get_valid_until()
    }

    Session.new()
    |> Session.sign_in_changeset(attrs)
    |> Repo.insert()
  end

  # todo: move to config
  @token_valid_length 7
  @token_valid_length_unit :day
  defp get_valid_until() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(@token_valid_length, @token_valid_length_unit)
  end

  def get_by_token(token) do
    token
    |> get_by_token_query()
    |> Repo.one()
  end

  defp get_by_token_query(token) do
    from(s in Session, where: s.token == ^token)
  end

  def get_account_by_token(token) do
    with %{account_id: account_id} <- get_by_token(token),
         %{} = account <- Accounts.get_account_by_id(account_id) do
      account
    else
      _ -> nil
    end
  end
end
