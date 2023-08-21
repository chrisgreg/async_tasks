defmodule AsyncTasks.Api do
  alias AsyncTasks.TravelData
  alias AsyncTasks.Repo
  import Ecto.Query

  def fetch_async_data(delay \\ 5000) do
    result = Task.await(fetch_data(delay))
    {:ok, result}
  end

  def fetch_data(delay) do
    parse_delay(delay) |> Process.sleep()
    Task.async(fn -> "Here is the result after #{delay}ms" end)
  end

  def parse_delay(delay) when is_integer(delay), do: delay
  def parse_delay(delay) when is_binary(delay), do: String.to_integer(delay)

  def fetch_and_store_data(delay \\ 5000) do
    {:ok, result} = Task.await(fetch_data(delay))
      |> store_data("database")

    {:ok, result}
  end

  def store_data(_results, demo_name) do
    %TravelData{}
    |> TravelData.changeset(%{fetched: true, demo: demo_name})
    |> Repo.insert()
  end

  def has_data?(demo_name) do
    Repo.exists?(TravelData, demo: demo_name)
  end

  def reset!(demo_name) do
    Repo.delete_all(from t in TravelData, where: t.demo == ^demo_name)
  end
end
