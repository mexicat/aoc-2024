defmodule AoC.Day04 do
  @dirs [{1, 0}, {0, 1}, {1, 1}, {1, -1}, {-1, 0}, {0, -1}, {-1, -1}, {-1, 1}]
  @dirs_diagonal [{1, 1}, {1, -1}, {-1, 1}, {-1, -1}]

  def part1(input) do
    grid = parse_input(input)

    grid
    |> Enum.filter(fn {_, v} -> v == "X" end)
    |> Enum.reduce(0, fn {{x, y}, _}, acc -> acc + find_xmas(grid, {x, y}) end)
  end

  def part2(input) do
    grid = parse_input(input)

    grid
    |> Enum.filter(fn {_, v} -> v == "A" end)
    |> Enum.reduce(0, fn {{x, y}, _}, acc -> acc + find_x_mas(grid, {x, y}) end)
  end

  def find_xmas(grid, {x, y}) do
    Enum.reduce(@dirs, 0, fn {dx, dy}, acc ->
      ["M", "A", "S"]
      |> Enum.reduce_while({nil, {x, y}}, fn c, {_, {x, y}} ->
        check = {x + dx, y + dy}

        case Map.get(grid, check) do
          ^c -> {:cont, {true, check}}
          _ -> {:halt, false}
        end
      end)
      |> case do
        {true, _} -> acc + 1
        _ -> acc
      end
    end)
  end

  def find_x_mas(grid, {x, y}) do
    @dirs_diagonal
    |> Enum.map(fn {dx, dy} -> Map.get(grid, {x + dx, y + dy}) end)
    |> case do
      ["M", "S", "M", "S"] -> 1
      ["M", "M", "S", "S"] -> 1
      ["S", "S", "M", "M"] -> 1
      ["S", "M", "S", "M"] -> 1
      _ -> 0
    end
  end

  def parse_input(input) do
    input
    |> String.codepoints()
    |> Enum.reduce({%{}, 0, 0}, fn c, {acc, x, y} ->
      case c do
        "\n" -> {acc, 0, y + 1}
        c -> {Map.put(acc, {x, y}, c), x + 1, y}
      end
    end)
    |> elem(0)
  end
end
