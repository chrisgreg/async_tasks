defmodule  AsyncTasksWeb.DatabaseLive do
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
    {:ok, result} = Api.fetch_async_data(delay)
    {:noreply, assign(socket, :result, result)}
  end

  def handle_event("reset", _, socket) do
    socket =
      socket
      |> assign(:result, nil)

    {:noreply, socket}
  end
end
