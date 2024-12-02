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
    Enum.reduce(l1, 0, fn x, acc -> acc + x * Enum.count(l2, &(&1 == x)) end)
  end

  def parse_input(input) do
    input
    |> String.split(["\n", " "], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
