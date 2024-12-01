defmodule AoC.Day01 do
  def part1(input) do
    [l1, l2] = parse_input(input)

    l1 = Enum.sort(l1)
    l2 = Enum.sort(l2)

    Enum.zip(l1, l2)
    |> Enum.map(fn {a, b} -> abs(b - a) end)
    |> Enum.sum()
  end

  def part2(input) do
    [l1, l2] = parse_input(input)

    Enum.reduce(l1, 0, fn x, acc ->
      acc + x * Enum.count(l2, fn y -> x == y end)
    end)
  end

  def parse_input(input) do
    input
    |> String.split(["\n", " "], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.zip()
    |> Enum.map(fn list ->
      list |> Tuple.to_list() |> Enum.map(&String.to_integer/1)
    end)
  end
end
