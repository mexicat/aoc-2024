defmodule AoC.Day03 do
  def part1(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, input)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part2(input) do
    Regex.scan(~r/mul\((\d+),(\d+)\)|do\(\)|don\'t\(\)/, input)
    |> Enum.reduce({0, :on}, fn x, {acc, mode} ->
      case {x, mode} do
        {["do()"], _} -> {acc, :on}
        {[_, a, b], :on} -> {acc + String.to_integer(a) * String.to_integer(b), :on}
        # both "don't"s and "mul"s with :off mode result in this
        {_, _} -> {acc, :off}
      end
    end)
    |> elem(0)
  end
end
