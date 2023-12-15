defmodule RssSubscriptionBotWeb.UserLoginLive do
  use RssSubscriptionBotWeb, :live_view

  def mount(_, _, socket) do
    username = socket.assigns.flash |> live_flash(:username)

    {:ok, socket |> assign(form: %{"username" => username} |> to_form(as: :account))}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello there!</h1>
    <.simple_form for={@form} phx-update="ignore" action={~p"/user/login"}>
      <.input field={@form[:username]} label="Username" required/>
      <.input field={@form[:pwd_string]} label="Password" type="password" required/>
      <:actions> 
        <.button phx-disable-with="Logging in...">
          Login
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end
