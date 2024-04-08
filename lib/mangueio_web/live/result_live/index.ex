defmodule MangueioWeb.ResultLive.Index do
  use MangueioWeb, :live_view

  alias Mangueio.Interests
  alias Mangueio.Interests.Result

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(socket, :results, Interests.list_results_by_interest(socket.assigns.interest.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Result")
    |> assign(:result, Interests.get_result!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Result")
    |> assign(:result, %Result{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Results")
    |> assign(:result, nil)
  end

  @impl true
  def handle_info({MangueioWeb.ResultLive.FormComponent, {:saved, result}}, socket) do
    {:noreply, stream_insert(socket, :results, result)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    result = Interests.get_result!(id)
    {:ok, _} = Interests.delete_result(result)

    {:noreply, stream_delete(socket, :results, result)}
  end
end
