defmodule AoC.Day05 do
  def part1(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.filter(&validate_update(&1, rules))
    |> Enum.map(fn update ->
      middle = update |> Enum.count() |> div(2)
      Enum.at(update, middle)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.reject(&validate_update(&1, rules))
    |> Enum.map(fn update ->
      update = fix_update(update, rules)
      middle = update |> Enum.count() |> div(2)
      Enum.at(update, middle)
    end)
    |> Enum.sum()
  end

  def validate_update(update, rules) do
    update
    |> Enum.with_index()
    |> Enum.reduce_while(nil, fn {x, i}, _ ->
      rules
      |> Enum.filter(fn [a, _] -> a == x end)
      |> Enum.map(fn [_, b] ->
        case Enum.find_index(update, &(&1 == b)) do
          nil -> true
          n when n > i -> true
          _ -> false
        end
      end)
      |> Enum.all?(& &1)
      |> case do
        true -> {:cont, true}
        false -> {:halt, false}
      end
    end)
  end

  def fix_update(update, rules) do
    Enum.reduce(update, [], fn x, acc ->
      index =
        Enum.reduce_while(0..length(acc), nil, fn i, _ ->
          acc
          |> Enum.slice(i..length(acc))
          |> Enum.all?(fn y ->
            Enum.any?(rules, fn [a, b] -> x == a && y == b end) &&
              not Enum.any?(rules, fn [a, b] -> y == a && x == b end)
          end)
          |> case do
            true -> {:halt, i}
            false -> {:cont, i}
          end
        end)

      List.insert_at(acc, index, x)
    end)
  end

  def parse_input(input) do
    [rules, updates] = String.split(input, "\n\n", trim: true)

    rules =
      rules
      |> String.split(["\n", "|"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> x |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) end)

    {rules, updates}
  end
end
