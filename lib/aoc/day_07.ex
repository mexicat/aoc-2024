defmodule AoC.Day07 do
  def part1(input) do
    input
    |> parse_input()
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.reject(fn {target, numbers} -> solve(target, numbers, [:+, :*]) == :error end)
    |> Flow.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.reject(fn {target, numbers} -> solve(target, numbers, [:+, :*, :||]) == :error end)
    |> Flow.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  def solve(target, numbers, allowed_ops) do
    numbers
    |> possible_values(allowed_ops)
    |> Map.get(target)
    |> case do
      nil -> :error
      operations -> {:ok, operations}
    end
  end

  def possible_values([first | rest], allowed_ops) do
    Enum.reduce(rest, %{first => []}, fn x, acc ->
      for {prev_value, ops} <- acc,
          op <- allowed_ops,
          result = get_op(op, prev_value, x) do
        {result, [op | ops]}
      end
      |> Map.new()
    end)
  end

  def get_op(:+, a, b), do: a + b
  def get_op(:*, a, b), do: a * b
  def get_op(:||, a, b), do: a - b

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [x | rest] = line |> String.split([" ", ":"], trim: true) |> Enum.map(&String.to_integer/1)
      {x, rest}
    end)
  end
end
