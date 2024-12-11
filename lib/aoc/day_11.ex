defmodule AoC.Day11 do
  def part1(input) do
    input |> parse_input() |> blink_times(25) |> Map.values() |> Enum.sum()
  end

  def part2(input) do
    input |> parse_input() |> blink_times(75) |> Map.values() |> Enum.sum()
  end

  def blink_times(stones, 0), do: stones

  def blink_times(stones, times) do
    stones
    |> Map.to_list()
    |> blink(%{})
    |> blink_times(times - 1)
  end

  def blink([], acc), do: acc

  def blink([{"0", n} | rest], acc) do
    blink(rest, Map.update(acc, "1", n, &(&1 + n)))
  end

  def blink([{x, n} | rest], acc) when x |> byte_size() |> rem(2) == 0 do
    {a, b} = x |> String.split_at(byte_size(x) |> div(2))

    b =
      case String.trim_leading(b, "0") do
        "" -> "0"
        x -> x
      end

    blink(rest, acc |> Map.update(a, n, &(&1 + n)) |> Map.update(b, n, &(&1 + n)))
  end

  def blink([{x, n} | rest], acc) do
    x = x |> String.to_integer() |> Kernel.*(2024) |> Integer.to_string()

    blink(rest, Map.update(acc, x, n, &(&1 + n)))
  end

  def parse_input(input) do
    input
    |> String.split([" ", "\n"], trim: true)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
