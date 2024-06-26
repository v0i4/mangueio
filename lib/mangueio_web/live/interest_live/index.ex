defmodule MangueioWeb.InterestLive.Index do
  use MangueioWeb, :live_view

  alias Mangueio.Interests.Interest
  alias Mangueio.Interests

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    current_tab = "interests"

    socket =
      socket
      |> assign(:current_tab, current_tab)

    {:ok, stream(socket, :interests, Interests.list_interests(user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
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
    |> assign(:interest, %Interest{user_id: socket.assigns.current_user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interests")
    |> assign(:interest, nil)
  end

  @impl true
  def handle_info({MangueioWeb.InterestLive.FormComponent, {:saved, interest}}, socket) do
    params =
      interest
      |> Map.from_struct()

    process(params, interest.id)

    {:noreply, stream_insert(socket, :interests, interest)}
  end

  def handle_info({:update_status, interest}, socket) do
    {:noreply, stream_insert(socket, :interests, interest)}
  end

  @impl true
  def handle_info({ref, result}, socket) do
    Process.demonitor(ref, [:flush])

    result
    |> Enum.map(fn item ->
      item =
        item
        |> Map.put(:currency, item.price.currency)
        |> Map.put(:price, item.price.value)

      try do
        Interests.create_result(item)
      rescue
        Ecto.ConstraintError ->
          to_update = Interests.get_result_by_url(item.url)
          Interests.update_result(to_update, item)
      end
    end)

    try do
      interest_id =
        List.first(result).interest_id

      result = Interests.list_results_by_interest(interest_id)

      interest =
        Interests.get_interest!(interest_id)

      {_, updated_interest} =
        Interests.update_interest(interest, %{status: "Concluido(#{Kernel.length(result)})"})

      send(self(), {:update_status, updated_interest})

      socket =
        socket
        |> stream(:results, result)
        |> assign(:interest_id, interest_id)

      {:noreply, stream(socket, :results, result) |> put_flash(:info, "garimpado!")}
    rescue
      _ ->
        {:noreply, socket |> put_flash(:error, "Nao encontramos itens para sua pesquisa :/ ")}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interest = Interests.get_interest!(id)
    {:ok, _} = Interests.delete_interest(interest)

    {:noreply, stream_delete(socket, :interests, interest)}
  end

  def handle_event("change-tab", %{"tab" => tab}, socket) do
    socket =
      socket
      |> assign(:current_tab, tab)

    socket.assigns.streams |> IO.inspect()

    {:noreply, socket}
  end

  def handle_event("interest-refresh", %{"interests" => interests}, socket) do
    {:noreply, socket |> assign(:interests, interests)}
  end

  def process(params, interest_id) do
    filters = %{
      min_price: params.min_price,
      max_price: params.max_price
    }

    term = params.keyword
    _location = params["location"]

    Task.async(fn -> Interests.merge_results_and_interests(term, filters, interest_id) end)
  end
end
