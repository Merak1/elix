defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view
  import LiveViewStudio.Helpers

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        brightness: 10,
        slider_value: 50,
        input_check: false,
        temperature: "3000"
      )

    IO.inspect(self(), label: "MOUNT")
    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background:#{temp_color(@temperature)}" }>
          <%= assigns.brightness %>%
        </span>
      </div>
      <button phx-click="on">
        <img src="/images/light-on.svg" alt="" />
      </button>
      <button phx-click="down">
        <img src="/images/down.svg" alt="" />
      </button>
      <button phx-click="up">
        <img src="/images/up.svg" alt="" />
      </button>
      <button phx-click="off">
        <img src="/images/light-off.svg" alt="" />
      </button>
      <br />
      <br />
      <div class="fire">
        <button phx-click="random">
          <img src="/images/fire.svg" alt="" />
        </button>
      </div>

      <form phx-change="slider-change">
        <input
          type="range"
          min="0"
          max="100"
          name="brightness"
          value={@slider_value}
        />
      </form>

      <br />
      <form phx-change="temperature-change">
        <div class="temps">
          <%= for temp <- ["3000", "4000", "5000"] do %>
            <div>
              <input
                type="radio"
                id={temp}
                name="temp"
                value={temp}
                checked={temp == @temperature}
              />
              <label for={temp}><%= temp %></label>
            </div>
          <% end %>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("temperature-change", %{"temp" => temperature}, socket) do
    red_map(temperature)
    socket = assign(socket, temperature: temperature)
    {:noreply, socket}
  end

  def handle_event("slider-change", params, socket) do
    brightness = String.to_integer(params["brightness"])
    # red_map(brightness)
    socket = assign(socket, brightness: brightness)
    {:noreply, socket}
  end

  def handle_event("random", _, socket) do
    # socket = assign(socket, brightness: :rand.uniform(100))
    socket = assign(socket, brightness: Enum.random(0..100))
    {:noreply, socket}
  end

  def handle_event("on", _, socket) do
    IO.inspect(self(), label: "ON")

    # raise "fire"
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    # brightness = socket.assigns.brightness
    # socket = assign(socket, brightness: brightness + 10)
    # socket = update(socket, :brightness, &(&1 + 10))
    # socket = update(socket, :brightness, fn value -> value + 10 end)
    # socket = update(socket, :brightness, &min(&1 + 10, 100))
    socket = update(socket, :brightness, fn value -> min(value + 10, 100) end)
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    # socket = update(socket, :brightness, &(&1 - 10))
    # socket = update(socket, :brightness, fn value -> value -10 end)
    # socket = update(socket, :brightness, fn value -> max(value - 10, 0) end)
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#FEFF66"
  defp temp_color("5000"), do: "#99CCFF"
end
