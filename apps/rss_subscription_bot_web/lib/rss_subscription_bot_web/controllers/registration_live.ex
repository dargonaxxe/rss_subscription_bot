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

  def handle_event("validate", _unsigned_params, socket) do
    # todo
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello there!</h1>
    <.simple_form for={@form} phx-change="validate" phx-submit="save">
      <.input field={@form[:username]} label="Username"/>
      <.input field={@form[:pwd_string]} label="Password" type="password"/>
      <:actions> 
        <.button>Save</.button>
      </:actions>
    </.simple_form>
    """
  end
end
