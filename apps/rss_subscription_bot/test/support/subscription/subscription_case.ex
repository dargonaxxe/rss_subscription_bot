defmodule RssSubscriptionBot.SubscriptionCase do
  alias RssSubscriptionBot.Core.Subscriptions
  alias RssSubscriptionBot.UserCase
  use ExUnit.CaseTemplate

  using do
    quote do
      use UserCase
      setup [:setup_user]

      defp setup_subscription(%{user: %{id: user_id}}) do
        {:ok, subscription} =
          Subscriptions.create_subscription(user_id, "url", "tg_handle", "name")

        %{subscription: subscription}
      end
    end
  end
end
