defmodule RssSubscriptionBotTest do
  use ExUnit.Case
  doctest RssSubscriptionBot

  test "greets the world" do
    assert RssSubscriptionBot.hello() == :world
  end
end
