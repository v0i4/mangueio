defmodule MangueioWeb.IndexLive do
  use MangueioWeb, :live_view

  alias Mangueio.Interests
  alias Mangueio.Interests.Interest

  @tab_enabled "inline-block p-4 text-white bg-black rounded-t-lg active dark:bg-gray-800 dark:text-blue-500"
  @tab_disabled "inline-block p-4 rounded-t-lg hover:text-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 dark:hover:text-gray-300"

  def mount(_params, _session, socket) do
    interests = Interests.list_interests(socket.assigns.current_user.id)
    current_tab = "searches"

    changeset = Interests.change_interest(%Interest{})
    form = to_form(changeset)

    socket =
      socket
      |> assign(:current_tab, current_tab)
      |> assign(:tab_enabled, @tab_enabled)
      |> assign(:tab_disabled, @tab_disabled)
      |> assign(:form, form)
      |> stream(:interests, interests)

    {:ok, socket}
  end

  def handle_event("set_current_tab", params, socket) do
    {:noreply, assign(socket, :current_tab, params["tab"])}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"interest" => params}, socket) do
    attrs = %{
      user_id: params["user_id"] |> String.to_integer(),
      location: params["location"],
      keyword: params["keyword"],
      min_price: params["min_price"] |> String.to_integer(),
      max_price: params["max_price"] |> String.to_integer()
    }

    new_interest = Interests.create_interest(attrs)

    case new_interest do
      {:ok, interest} ->
        socket =
          update(socket, :interests, fn interests -> [interest | interests] end)

        changeset = Interests.change_interest(%Interest{})
        {:noreply, socket |> assign(:form, to_form(changeset))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(:form, to_form(changeset))}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    interest =
      Interests.get_interest!(id |> String.to_integer())

    {:ok, _interest} = interest |> Interests.delete_interest()

    {:noreply, stream_delete(socket, :interests, interest)}
  end

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      O que voce quer encontrar?
    </.header>

    <div class="mx-auto w-full">
      <ul class="flex flex-wrap text-sm font-medium text-center text-gray-500 border-b border-gray-200 dark:border-gray-700 dark:text-gray-400 py-4">
        <li class="me-2">
          <a
            href="#"
            aria-current="page"
            class={if @current_tab == "searches", do: @tab_enabled, else: @tab_disabled}
            phx-click="set_current_tab"
            phx-value-tab="searches"
          >
            Buscas
          </a>
        </li>
        <li class="me-2">
          <a
            href="#"
            class={if @current_tab == "results", do: @tab_enabled, else: @tab_disabled}
            phx-click="set_current_tab"
            phx-value-tab="results"
          >
            <%= render_results(assigns) %>
          </a>
        </li>
      </ul>
      <div name="content" class="p-4 bg-white rounded-lg dark:bg-gray-800">
        <%= case @current_tab do %>
          <% "searches" -> %>
            <%= render_searches(assigns) %>
          <% "results" -> %>
        <% end %>
      </div>
    </div>
    """
  end

  defp render_searches(assigns) do
    ~H"""
    <div class="flex">
      <.form for={@form} class="grid grid-cols-6 gap-3" phx-change="validate" phx-submit="save">
        <.input field={@form[:keyword]} type="text" placeholder="Palavras Chaves" />
        <.input field={@form[:location]} type="text" placeholder="Localização" />
        <.input field={@form[:min_price]} type="text" placeholder="Preco Minimo" />
        <.input field={@form[:max_price]} type="text" placeholder="Preco Maximo" />
        <.input field={@form[:user_id]} type="hidden" value={assigns.current_user.id} />
        <.button phx-disable-with="garimpando...">Buscar</.button>
      </.form>
    </div>
    <div class="mx-auto w-full py-4">
      <div
        :for={{_, interest} <- @streams.interests}
        id="interests"
        class="grid grid-cols-8 gap-3 py-4"
      >
        <div><%= interest.keyword %></div>
        <div><%= interest.location %></div>
        <div><%= interest.min_price %></div>
        <div><%= interest.max_price %></div>
        <.link href={~p"/interests/#{interest.id}/edit/"}>edit</.link>
        <.link href="#" phx-click="delete" phx-value-id={interest.id}>delete</.link>
      </div>
    </div>
    """
  end

  defp render_results(assigns) do
    ~H"""
    results
    """
  end
end
