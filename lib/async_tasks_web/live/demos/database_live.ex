defmodule  AsyncTasksWeb.DatabaseLive do
  use AsyncTasksWeb, :live_view
  alias AsyncTasks.Api

  @demo_name "database"

  def mount(_params, _session, socket) do
    result = Api.has_data?(@demo_name)

    socket =
      socket
      |> assign(:result, result)
      |> assign(:loading, false)

    {:ok, socket}
  end

  def handle_event("start-async-task", %{"delay" => delay}, socket) do
    fetch_data(delay) |> IO.inspect()

    socket =
      socket
      |> assign(:loading, true)
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def handle_event("reset", _, socket) do
    Api.reset!(@demo_name) |> IO.inspect()

    socket =
      socket
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def fetch_data(delay) do
    pid = self()

    # The async task process is linked to the parent LiveView process
    # When the LiveView process exits, it kills any linked processes like the async task
    # So the async task is terminated early before completion
    # Any database inserts or external side effects are not applied
    # So we have to use a TaskSupervisor which uses an external BEAM process
    Task.Supervisor.async_nolink(AsyncTasks.TaskSupervisor, fn ->
      result = Api.fetch_and_store_data(delay)
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
    {:noreply, socket}
  end
end
