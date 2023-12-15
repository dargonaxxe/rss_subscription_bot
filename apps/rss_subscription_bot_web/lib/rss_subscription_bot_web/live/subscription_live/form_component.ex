defmodule RssSubscriptionBotWeb.SubscriptionLive.FormComponent do
  alias RssSubscriptionBot.Core.Users
  alias RssSubscriptionBot.Core.Subscriptions
  alias RssSubscriptionBot.Core.Subscription
  use RssSubscriptionBotWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage subscription records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="subscription-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:url]} type="text" label="Url" />
        <.input field={@form[:tg_handle]} type="text" label="Tg handle" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Subscription</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{subscription: subscription} = assigns, socket) do
    changeset = Subscription.changeset(subscription)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"subscription" => subscription_params}, socket) do
    changeset =
      socket.assigns.subscription
      |> Subscription.changeset(subscription_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"subscription" => subscription_params}, socket) do
    save_subscription(socket, socket.assigns.action, subscription_params)
  end

  defp save_subscription(socket, :new, subscription_params) do
    user_id =
      socket.assigns
      |> Map.get(:account)
      |> Map.get(:id)
      |> Users.get_user_by_account_id()
      |> Map.get(:id)

    %{"url" => url, "tg_handle" => tg_handle, "name" => name} =
      subscription_params

    user_id
    |> Subscriptions.create_subscription(url, tg_handle, name)
    |> case do
      {:ok, subscription} ->
        notify_parent({:saved, subscription})

        {:noreply,
         socket
         |> put_flash(:info, "Subscription created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
