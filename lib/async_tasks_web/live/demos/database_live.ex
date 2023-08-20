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
end
