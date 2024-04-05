defmodule MangueioWeb.InterestLive.Index do
  use MangueioWeb, :live_view

  alias Mangueio.Interests
  alias Mangueio.Interests.Interest

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    {:ok, stream(socket, :interests, Interests.list_interests(user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    params = Map.put(params, "user_id", socket.assigns.current_user.id)
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Interest")
    |> assign(:interest, Interests.get_interest!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Interest")
    |> assign(:interest, %Interest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interests")
    |> assign(:interest, nil)
  end

  @impl true
  def handle_info({MangueioWeb.InterestLive.FormComponent, {:saved, interest}}, socket) do
    {:noreply, stream_insert(socket, :interests, interest)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interest = Interests.get_interest!(id)
    {:ok, _} = Interests.delete_interest(interest)

    {:noreply, stream_delete(socket, :interests, interest)}
  end
end
