defmodule AsyncTasksWeb.NoOptimisationLive do
  use AsyncTasksWeb, :live_view
  alias AsyncTasks.Api

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:result, nil)

    {:ok, socket}
  end

  def handle_event("start-async-task", %{"delay" => delay}, socket) do
    {:ok, result} = Api.fetch_async_data(delay)
    {:noreply, assign(socket, :result, result)}
  end

  def handle_event("reset", _, socket) do
    socket =
      socket
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.back navigate={~p"/"}>Back</.back>
      <.header class="mt-4">
        This demo is not optimised -
        <span class="font-extrabold text-red-700">Process ID: <%= raw(inspect(self())) %></span>
      </.header>
      <div class="mt-12">
        <.button phx-click="start-async-task" phx-value-delay={500}>500ms delay task</.button>
        <.button phx-click="start-async-task" phx-value-delay={5000}>5000ms delay task</.button>
        <.button phx-click="start-async-task" phx-value-delay={50_000}>50000ms delay task</.button>
        <.button phx-click="reset" class="bg-red-800">Reset</.button>

        <div class="grid place-items-center">
          <p class="text-3xl font-bold mt-8"><%= @result %></p>
        </div>
      </div>
    </div>
    """
  end
end
