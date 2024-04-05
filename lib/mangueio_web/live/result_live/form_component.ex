defmodule MangueioWeb.ResultLive.FormComponent do
  use MangueioWeb, :live_component

  alias Mangueio.Interests

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage result records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="result-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:url]} type="text" label="Url" />
        <.input field={@form[:image]} type="text" label="Image" />
        <.input field={@form[:price]} type="number" label="Price" />
        <.input field={@form[:currency]} type="text" label="Currency" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:location]} type="text" label="Location" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Result</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{result: result} = assigns, socket) do
    changeset = Interests.change_result(result)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"result" => result_params}, socket) do
    changeset =
      socket.assigns.result
      |> Interests.change_result(result_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"result" => result_params}, socket) do
    save_result(socket, socket.assigns.action, result_params)
  end

  defp save_result(socket, :edit, result_params) do
    case Interests.update_result(socket.assigns.result, result_params) do
      {:ok, result} ->
        notify_parent({:saved, result})

        {:noreply,
         socket
         |> put_flash(:info, "Result updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_result(socket, :new, result_params) do
    case Interests.create_result(result_params) do
      {:ok, result} ->
        notify_parent({:saved, result})

        {:noreply,
         socket
         |> put_flash(:info, "Result created successfully")
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
