defmodule AsyncTasksWeb.TipsComponent do
  use AsyncTasksWeb, :live_component

  def mount(_, _, socket) do
    socket = assign(socket, tip: Enum.random(tips()))
    {:ok, socket}
  end

  def update(_, socket) do
    {:ok, assign(socket, tip: Enum.random(tips()))}
  end

  def handle_event("next-tip", _, socket) do
    {:noreply, assign(socket, tip: Enum.random(tips()))}
  end

  def tips do
    [
      "Kyoto was the capital of Japan for over 1,000 years until 1868.",
      "It is located in the Kansai region on the island of Honshu.",
      "Kyoto has over 2,000 Buddhist temples and Shinto shrines.",
      "The city is known for its traditional wooden houses, gardens, geisha districts, and kaiseki cuisine.",
      "Major festivals in Kyoto include Aoi Matsuri, Gion Matsuri, and Jidai Matsuri.",
      "Kyoto did not suffer major damage during WWII and retains much of its historic architecture.",
      "The city has a population of about 1.5 million people.",
      "Three major universities are located in Kyoto - Kyoto University, Doshisha University, and Ritsumeikan University.",
      "The Philosopher's Walk is a famous pedestrian path along a canal lined with cherry trees.",
      "Kyoto Protocol on climate change was signed here in 1997."
    ]
  end

  def render(assigns) do
    ~H"""
      <div class=" bg-orange-100 bg-opacity-80 p-4 rounded-lg flex-row flex justify-between rem">
        <div class="w-full">
          <h2 class="font-semibold text-sm text-orange-900">Did you know?</h2>
          <p class="text-orange-900 text-xl pr-8">
            <%= @tip %>
          </p>
        </div>
        <div class="w-28 flex flex-col justify-center align-items">
          <.button phx-click="next-tip" phx-target={@myself} class="h-12 w-full">Next Tip</.button>
        </div>
      </div>
    """
  end
end
