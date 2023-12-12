defmodule RssSubscriptionBot.Rss.Otp.UsersSubscriptionObserverTest do
  alias RssSubscriptionBot.Rss.Otp.UsersSubscriptionObserver
  alias RssSubscriptionBot.UserCase
  use UserCase

  describe "start_link/0" do
    test "should start without errors" do
      {:ok, _} = UsersSubscriptionObserver.start_link()
    end
  end
end
