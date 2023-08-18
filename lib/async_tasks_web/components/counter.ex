defmodule AsyncTasksWeb.CounterComponent do
  use AsyncTasksWeb, :live_component

  def update(_, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-row align-center mt-8 justify-center align-items items-center gap-2">
      <.button class="w-12 bg-green-700" phx-target={@myself} phx-click="increment">+</.button>
      <.button class="w-12 bg-pink-600" phx-target={@myself} phx-click="decrement">-</.button>
      <p class="font-bold w-12 text-2xl"><%= assigns.count %></p>
    </div>
    """
  end

  def handle_event("increment", _, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end

  def handle_event("decrement", _, socket) do
    {:noreply, assign(socket, count: socket.assigns.count - 1)}
  end
end
