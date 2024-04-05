defmodule MangueioWeb.InterestLive.Show do
  use MangueioWeb, :live_view

  alias Mangueio.Interests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interest, Interests.get_interest!(id))}
  end

  defp page_title(:show), do: "Show Interest"
  defp page_title(:edit), do: "Edit Interest"
end
