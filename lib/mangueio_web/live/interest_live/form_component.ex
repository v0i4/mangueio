defmodule MangueioWeb.InterestLive.FormComponent do
  use MangueioWeb, :live_component

  alias Mangueio.Interests

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage interest records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="interest-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:keyword]} type="text" label="Keyword" />
        <.input field={@form[:location]} type="select" label="Location" options={["Grande Floripa"]} />
        <.input field={@form[:min_price]} type="number" label="Min price" />
        <.input field={@form[:max_price]} type="number" label="Max price" />
        <.input field={@form[:user_id]} type="hidden" value={@user_id} />
        <.input field={@form[:id]} type="hidden" value={@id} />
        <.input field={@form[:status]} type="hidden" value={@status} />
        <:actions>
          <.button phx-disable-with="Garimpando...">Processar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{interest: interest} = assigns, socket) do
    changeset = Interests.change_interest(interest)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"interest" => interest_params}, socket) do
    changeset =
      socket.assigns.interest
      |> Interests.change_interest(interest_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"interest" => interest_params}, socket) do
    save_interest(socket, socket.assigns.action, interest_params)
  end

  defp save_interest(socket, :edit, interest_params) do
    case Interests.update_interest(socket.assigns.interest, interest_params) do
      {:ok, interest} ->
        notify_parent({:saved, interest})

        {:noreply,
         socket
         |> put_flash(:info, "Sua busca esta sendo processada!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_interest(socket, :new, interest_params) do
    case Interests.create_interest(interest_params) do
      {:ok, interest} ->
        notify_parent({:saved, interest})

        {:noreply,
         socket
         |> put_flash(:info, "Interest created successfully")
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
