defmodule RssSubscriptionBotWeb.RegistrationLive do
  alias RssSubscriptionBot.Core.Users
  alias RssSubscriptionBot.Core.Accounts
  alias Ecto.Changeset
  alias RssSubscriptionBot.Core.Account
  use RssSubscriptionBotWeb, :live_view

  def mount(_, _, socket) do
    socket = socket |> assign_account() |> assign(trigger_submit: false) |> assign_changeset()
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

  def handle_event("validate", %{"account" => attrs}, %{assigns: %{account: account}} = socket) do
    changeset =
      account
      |> Account.registration_changeset(attrs)
      |> Map.put(:action, :validate)

    socket = socket |> assign_form(changeset)
    {:noreply, socket}
  end

  def handle_event("save", %{"account" => account}, socket) do
    %{"username" => username, "pwd_string" => pwd_string} = account

    with {:ok, account} <- Accounts.create_account(username, pwd_string),
         {:ok, _} <- Users.create_user(account.id) do
      {:noreply,
       socket |> put_flash(:info, "Account created successfully") |> assign(trigger_submit: true)}

      # todo: navigate somewhere else 
    else
      {:error, %Changeset{} = changeset} ->
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <h1>Hello there!</h1>
    <.simple_form for={@form} phx-change="validate" phx-submit="save" action={~p"/user/login"} method="post" phx-trigger-action={@trigger_submit}>
      <.input field={@form[:username]} label="Username"/>
      <.input field={@form[:pwd_string]} label="Password" type="password"/>
      <:actions> 
        <.button>Sign up</.button>
      </:actions>
    </.simple_form>
    """
  end
end
