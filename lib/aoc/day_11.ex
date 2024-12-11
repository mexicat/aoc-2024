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

  def blink([{0, n} | rest], acc) do
    blink(rest, Map.update(acc, 1, n, &(&1 + n)))
  end

  def blink([{x, n} | rest], acc) do
    digits = Integer.digits(x)

    case rem(Enum.count(digits), 2) do
      0 ->
        {a, b} = Enum.split(digits, div(Enum.count(digits), 2))

        acc =
          acc
          |> Map.update(Integer.undigits(a), n, &(&1 + n))
          |> Map.update(Integer.undigits(b), n, &(&1 + n))

        blink(rest, acc)

      1 ->
        blink(rest, Map.update(acc, x * 2024, n, &(&1 + n)))
    end
  end

  def parse_input(input) do
    input
    |> String.split([" ", "\n"], trim: true)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, String.to_integer(x), 1, &(&1 + 1)) end)
  end
end
