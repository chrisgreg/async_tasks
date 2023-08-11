defmodule AsyncTasksWeb.LoadingLive do
  use AsyncTasksWeb, :live_view
  alias AsyncTasks.Api

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:result, nil)
      |> assign(:loading, false)

    {:ok, socket}
  end

  def handle_event("start-async-task", %{"delay" => delay}, socket) do
    fetch_data(delay)

    socket =
      socket
      |> assign(:loading, true)
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def handle_event("reset", _, socket) do
    socket =
      socket
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def fetch_data(delay) do
    pid = self()

    Task.async(fn ->
      result = Api.fetch_async_data(delay)
      send(pid, result)
    end)
  end

  def handle_info({:ok, result}, socket) do
    socket =
      socket
      |> assign(:loading, false)
      |> assign(:result, result)

    {:noreply, socket}
  end

  def handle_info(message, socket) do
    IO.inspect(message)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.back navigate={~p"/"}>Back</.back>
      <.header class="mt-4">
        This demo has slightly better UX -
        <span class="font-extrabold text-red-700">Process ID: <%= raw(inspect(self())) %></span>
      </.header>
      <div class="mt-12">
        <.button phx-click="start-async-task" phx-value-delay={500}>500ms delay task</.button>
        <.button phx-click="start-async-task" phx-value-delay={5000}>5000ms delay task</.button>
        <.button phx-click="start-async-task" phx-value-delay={50_000}>50000ms delay task</.button>
        <.button phx-click="reset" class="bg-red-800">Reset</.button>

        <div class="grid place-items-center mt-8">
          <p :if={@loading}>
            <.icon name="hero-arrow-path" class="animate-spin h-5 w-5" /> Loading...
          </p>
          <p class="text-3xl font-bold"><%= @result %></p>
        </div>
      </div>
    </div>
    """
  end
end
