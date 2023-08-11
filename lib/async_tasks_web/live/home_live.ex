defmodule AsyncTasksWeb.HomeLive do
  use AsyncTasksWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>Home</.header>
    <.link navigate={~p"/demos/no-optimisation"}>
      <.button>Bad Async Tasks</.button>
    </.link>
    <.link navigate={~p"/demos/loading"}>
      <.button>Daredevil UX Async Tasks</.button>
    </.link>
    """
  end
end
