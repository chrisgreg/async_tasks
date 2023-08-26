defmodule  AsyncTasksWeb.FinalLive do
  use AsyncTasksWeb, :live_view
  alias AsyncTasks.Api

  @demo_name "final"

  def mount(_params, _session, socket) do
    result = Api.has_data?(@demo_name)

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
    Api.fetch_and_store_and_emit_data(@demo_name, delay)
  end

  def handle_info({Api, [:data, :fetched], result}, socket) do
    socket = socket
    |> assign(%{result: true, loading: false})

    {:noreply, socket}
  end

  def handle_info(message, socket) do
    {:noreply, socket}
  end
end
