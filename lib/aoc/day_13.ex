defmodule AoC.Day13 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn machine -> machine |> win_prize() |> score() end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn machine ->
      machine
      |> List.update_at(-1, &(&1 + 10_000_000_000_000))
      |> List.update_at(-2, &(&1 + 10_000_000_000_000))
      |> win_prize()
      |> score()
    end)
    |> Enum.sum()
  end

  def win_prize([ax, ay, bx, by, px, py]) do
    res = ax * by - ay * bx

    {an, ar} = divmod(px * by - py * bx, res)
    {bn, br} = divmod(ax * py - ay * px, res)

    cond do
      ar != 0 or br != 0 -> :error
      true -> {an, bn}
    end
  end

  def score(:error), do: 0
  def score({a, b}), do: a * 3 + b * 1

  def divmod(a, b), do: {div(a, b), rem(a, b)}

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn block ->
      block
      |> String.split(
        ["\n", "Button A: X+", ", Y+", "Button B: X+", "Prize: X=", ", Y="],
        trim: true
      )
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
