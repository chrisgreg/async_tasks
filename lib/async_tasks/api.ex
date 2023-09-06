defmodule AsyncTasks.Api do
  alias AsyncTasks.{TravelData, Repo}
  alias ExternalService
  import Ecto.Query

  def fetch_async_data(delay \\ 5000) do
    result = ExternalService.fetch_data(delay) |> Task.await()
    {:ok, result}
  end

  def fetch_and_store_data(delay \\ 5000) do
    ExternalService.fetch_data(delay)
    |> Task.await()
    |> store_data("database")
  end

  def fetch_and_store_and_emit_data(demo_name, delay \\ 5000) do
    ExternalService.fetch_data(delay)
    |> store_data(demo_name)
    |> notify_subscribers([:data, :fetched])
  end

  def fetch_and_fail(demo_name, delay \\ 5000) do
    result = ExternalService.fetch_data(delay)
    notify_subscribers({:ok, result}, [:data, :error])
  end

  def store_data(_results, demo_name) do
    %TravelData{}
    |> TravelData.changeset(%{fetched: true, demo: demo_name})
    |> Repo.insert()
  end

  # Database functions
  def has_data?(demo_name) do
    Repo.exists?(from t in TravelData, where: t.demo == ^demo_name)
  end

  def reset!(demo_name) do
    Repo.delete_all(from t in TravelData, where: t.demo == ^demo_name)
  end

  ## PubSub ##
  @topic "async_tasks"

  def subscribe do
    Phoenix.PubSub.subscribe(AsyncTasks.PubSub, @topic)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(AsyncTasks.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _), do: {:error, reason}
end
