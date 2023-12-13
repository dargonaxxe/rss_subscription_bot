defmodule RssSubscriptionBot.Core.TgUser.TgUsersTest do
  alias RssSubscriptionBot.Core.TgUsers
  alias RssSubscriptionBot.RepoCase

  use RepoCase

  @tg_id 1
  @handle "handle"
  @handle_2 "another_handle"
  test "should successfully create tg_user" do
    {:ok, _} = TgUsers.new_user(@tg_id, @handle)
  end

  test "should alter handle" do
    {:ok, _} = TgUsers.new_user(@tg_id, @handle)
    {:ok, %{handle: @handle_2}} = TgUsers.new_user(@tg_id, @handle_2)
  end

  test "should find user by handle" do
    {:ok, user_1} = TgUsers.new_user(@tg_id, @handle)
    user_2 = TgUsers.find_by_handle(@handle)
    assert(user_2 == user_1)
  end
end
