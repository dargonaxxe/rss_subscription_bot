defmodule RssSubscriptionBotWeb.RegistrationLive do
  alias Ecto.Changeset
  alias RssSubscriptionBot.Core.Account
  use RssSubscriptionBotWeb, :live_view

  def mount(_, _, socket) do
    socket = socket |> assign_account() |> assign_changeset()
    {:ok, socket}
  end

  def assign_account(socket) do
    socket |> assign(account: Account.new())
  end

  def assign_changeset(%{assigns: %{account: account}} = socket) do
    changeset = account |> Account.registration_changeset(%{})
    socket |> assign_form(changeset)
  end

  def assign_form(socket, %Changeset{} = changeset) do
    socket |> assign(form: changeset |> to_form())
  end

  def render(assigns) do
    ~H"""
    <h1>Hello there!</h1>
    """
  end
end
