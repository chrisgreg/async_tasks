defmodule AsyncTasksWeb.LoadingLive do
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
    fetch_data(delay)

    socket =
      socket
      |> assign(:loading, true)
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def handle_event("reset", _, socket) do
    socket =
      socket
      |> assign(:result, nil)

    {:noreply, socket}
  end

  def fetch_data(delay) do
    Task.async(fn ->
      Api.fetch_async_data(delay)
    end)
  end

  def handle_info({ref, result}, socket) do
    Process.demonitor(ref, [:flush])

    socket =
      socket
      |> assign(:loading, false)
      |> assign(:result, result)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-5 grid-rows-1 h-[85vh] shadow-lg rounded-2xl  bg-[url('/images/purple-temple.png')] bg-contain">
      <div class="col-span-3 h-full bg-no-repeat rounded-l-lg flex flex-col justify-between">
        <div class="text-white text-4xl font-bold pt-12 pl-12 rem">
          Slow Travel
        </div>
        <div class="relative">
          <div class="absolute bottom-12 left-12 right-12 ">
            <div class="bg-white rounded-full uppercase text-sm w-fit px-4 py-2 font-bold mb-4 shadow-lg">
              Japan
            </div>
            <.live_component module={AsyncTasksWeb.TipsComponent} id="tips" />
          </div>
        </div>
      </div>
      <div class="col-span-2 bg-white rounded-2xl">
      <div class="flex flex-row justify-between items-center w-full m-8">
          <h2 class="uppercase font-bold px-3 py-2 rounded bg-zinc-200 text-pink-500 w-fit text-xs">UI Loading demo</h2>
          <.link
            navigate={~p"/demos/db-backed"}
            class="rounded-lg bg-zinc-100 px-3 py-2 hover:bg-zinc-200/80 mr-12 font-semibold text-sm"
          >
            Even Better Demo <span aria-hidden="true">&rarr;</span>
          </.link>
        </div>
        <div class="flex flex-row justify-around mt-8">
            <.button phx-click="start-async-task" phx-value-delay={500}>500ms</.button>
            <.button phx-click="start-async-task" phx-value-delay={5000}>5000ms</.button>
            <.button phx-click="start-async-task" phx-value-delay={50_000}>50000ms</.button>
            <.button phx-click="reset" class="bg-red-800">Reset</.button>
        </div>
        <div>
          <div class="flex flex-row items-center justify-between pt-12 px-16">
            <h2 class="text-4xl text-zinc-700 font-semibold rem">Kyoto</h2>
            <p :if={@loading}>
              <.icon name="hero-arrow-path" class="animate-spin h-5 w-5" /> Loading...
            </p>
          </div>
          <div class="grid grid-cols-2 p-12 gap-4 pt-4">
            <.placeholder_day day="Monday" content={@result} image="blue-bridge" />
            <.placeholder_day day="Tuesday" content={@result} image="pink-bridge" />
            <.placeholder_day day="Wednesday" content={@result} image="purple-streets" />
            <.placeholder_day day="Thursday" content={@result} image="yellow-temple" />
            <.placeholder_day day="Friday" content={@result} image="purple-temple" />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
