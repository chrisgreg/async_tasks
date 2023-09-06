defmodule  AsyncTasksWeb.PubSubLive do
  use AsyncTasksWeb, :live_view
  alias AsyncTasks.Api

  @demo_name "pubsub"

  def mount(_params, _session, socket) do
    result = Api.has_data?(@demo_name)

    if connected?(socket), do: Api.subscribe()

    socket =
      socket
      |> assign(:result, result)
      |> assign(:loading, false)
      |> assign(:will_error?, false)

    {:ok, socket}
  end

  def handle_event("start-async-task", %{"delay" => delay}, socket) do
    fetch_data(delay, socket.assigns.will_error?)

    socket =
      socket
      |> assign(:loading, true)
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def handle_event("toggle-error", _, socket) do
    socket = assign(socket, :will_error?, !socket.assigns.will_error?)
    {:noreply, socket}
  end

  def handle_event("reset", _, socket) do
    Api.reset!(@demo_name)

    socket =
      socket
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def fetch_data(delay, false) do
    Task.Supervisor.async_nolink(AsyncTasks.TaskSupervisor, fn ->
      Api.fetch_and_store_and_emit_data(@demo_name, delay)
    end)
  end

  def fetch_data(delay, true) do
    Task.Supervisor.async_nolink(AsyncTasks.TaskSupervisor, fn ->
      Api.fetch_and_fail(@demo_name, delay)
    end)
  end

  def handle_info({Api, [:data, :fetched], _result}, socket) do
    socket = socket
    |> assign(%{result: true, loading: false})

    {:noreply, socket}
  end

  def handle_info({Api, [:data, :error], _result}, socket) do
    socket = socket
    |> assign(%{result: false, loading: false})
    |> put_flash(:error, "Failed to fetch data, please try again.")

    {:noreply, socket}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
