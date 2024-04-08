defmodule MangueioWeb.ResultLive.Show do
  use MangueioWeb, :live_view

  alias Mangueio.Interests

  @impl true
  def mount(params, _session, socket) do
    id =
      params["id"]
      |> String.to_integer()

    {:ok, stream(socket, :results, Interests.list_results_by_interest(id))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    id = String.to_integer(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:result, Interests.list_results_by_interest(id))}
  end

  defp page_title(:show), do: "Show Result"
  defp page_title(:edit), do: "Edit Result"
end
