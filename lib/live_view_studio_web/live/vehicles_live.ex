defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        vehicles: [],
        loading: false,
        matches: %{}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <form phx-submit="search" phx-change="suggest">
        <input
          type="text"
          name="query"
          value=""
          placeholder="Make or model"
          autofocus
          autocomplete="off"
          list="matches"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>
      <div :if={@loading} class="loader">Loading...</div>

      <datalist id="matches">
        <option :for={match <- @matches} value={match}>
          <%= match %>
        </option>
      </datalist>

      <div class="vehicles">
        <ul>
          <li :for={vehicle <- @vehicles}>
            <span class="make-model">
              <%= vehicle.make_model %>
            </span>
            <span class="color">
              <%= vehicle.color %>
            </span>
            <span class={"status #{vehicle.status}"}>
              <%= vehicle.status %>
            </span>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("suggest", %{"query" => query}, socket) do
    socket = assign(socket, matches: Vehicles.suggest(query))

    LiveViewStudio.Helpers.red_map(socket)
    {:noreply, socket}
  end

  def handle_event("search", %{"query" => vehicle}, socket) do
    IO.inspect(vehicle)
    send(self(), {:run_search, vehicle})

    socket =
      assign(socket,
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_search, vehicle}, socket) do
    socket =
      assign(socket,
        vehicles: Vehicles.search(vehicle),
        loading: false
      )

    {:noreply, socket}
  end
end
