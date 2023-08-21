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
    <.link navigate={~p"/demos/db-backed"}>
      <.button>Database Backed</.button>
    </.link>
    <.link navigate={~p"/demos/pubsub"}>
      <.button>PubSub Backed</.button>
    </.link>
    <.link navigate={~p"/demos/final"}>
      <.button>All put together</.button>
    </.link>
    """
  end
end
