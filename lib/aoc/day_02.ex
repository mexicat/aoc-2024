defmodule AoC.Day02 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.count(&validate(&1, nil))
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.count(fn report ->
      case validate(report, nil) do
        true ->
          true

        false ->
          report
          |> Enum.with_index()
          |> Enum.any?(fn {_x, i} -> report |> List.delete_at(i) |> validate(nil) end)
      end
    end)
  end

  def validate([a, b | rest], nil) when a > b, do: validate([a, b | rest], :decr)
  def validate([a, b | rest], nil) when a < b, do: validate([a, b | rest], :incr)

  def validate([a, b | rest], :decr) when a - b <= 3 and a - b >= 1,
    do: validate([b | rest], :decr)

  def validate([a, b | rest], :incr) when b - a <= 3 and b - a >= 1,
    do: validate([b | rest], :incr)

  def validate([_, _ | _], _), do: false
  def validate([_], _), do: true

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end
end
