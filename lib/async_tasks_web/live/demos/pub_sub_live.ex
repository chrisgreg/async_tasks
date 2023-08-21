defmodule  AsyncTasksWeb.PubSubLive do
  use AsyncTasksWeb, :live_view
  alias AsyncTasks.Api

  @demo_name "pubsub"

  def mount(_params, _session, socket) do
    result = Api.has_data?(@demo_name) |> IO.inspect()

    if connected?(socket), do: Api.subscribe()

    socket =
      socket
      |> assign(:result, result)
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
    Api.reset!(@demo_name)

    socket =
      socket
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def fetch_data(delay) do
    Task.Supervisor.async_nolink(AsyncTasks.TaskSupervisor, fn ->
      Api.fetch_and_store_and_emit_data(delay)
    end)
  end

  def handle_info({Api, [:data, :fetched], result}, socket) do
    socket
    |> assign(socket, %{result: result, loading: false})
    |> push_event("data-fetched", %{result: result})

    {:noreply, socket}
  end

  def handle_info(message, socket) do
    {:noreply, socket}
  end
end
