defmodule AoC.Day02 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.count(&validate_report(&1, nil))
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.count(fn report ->
      case validate_report(report, nil) do
        true ->
          true

        false ->
          report
          |> Enum.with_index()
          |> Enum.any?(fn {_x, i} -> report |> List.delete_at(i) |> validate_report(nil) end)
      end
    end)
  end

  def validate_report([a, b | rest], nil) when a > b,
    do: validate_report([a, b | rest], :decreasing)

  def validate_report([a, b | rest], nil) when a < b,
    do: validate_report([a, b | rest], :increasing)

  def validate_report([a, b | _], _) when a == b, do: false

  def validate_report([a, b | rest], :decreasing) do
    if a - b <= 3 && a - b >= 1, do: validate_report([b | rest], :decreasing), else: false
  end

  def validate_report([a, b | rest], :increasing) do
    if b - a <= 3 && b - a >= 1, do: validate_report([b | rest], :increasing), else: false
  end

  def validate_report([_], _), do: true

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end
end
