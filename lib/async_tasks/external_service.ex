defmodule ExternalService do
  def fetch_data(delay) do
    parse_delay(delay) |> Process.sleep()
    Task.async(fn -> "Here is the result after #{delay}ms" end)
  end

  defp parse_delay(delay) when is_integer(delay), do: delay
  defp parse_delay(delay) when is_binary(delay), do: String.to_integer(delay)
end
