defmodule AsyncTasks.Api do
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
end
