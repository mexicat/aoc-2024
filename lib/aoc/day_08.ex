defmodule AoC.Day08 do
  def part1(input) do
    {grid, max_x, max_y} = AoC.Grid.parse_grid_to_map(input, ["."])

    grid
    |> Enum.group_by(fn {_, v} -> v end, fn {k, _} -> k end)
    |> Enum.reduce(MapSet.new(), fn {_, v}, acc ->
      v
      |> Formulae.combinations(2)
      |> Enum.reduce(acc, fn [p1, p2], acc ->
        {dx, dy} = distance(p1, p2)

        antinodes(p1, p2, dx, dy)
        |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or x > max_x or y > max_y end)
        |> Enum.into(acc)
      end)
    end)
    |> MapSet.size()
  end

  def part2(input) do
    {grid, max_x, max_y} = AoC.Grid.parse_grid_to_map(input, ["."])

    grid
    |> Enum.group_by(fn {_, v} -> v end, fn {k, _} -> k end)
    |> Enum.reduce(MapSet.new(), fn {_, v}, acc ->
      v
      |> Formulae.combinations(2)
      |> Enum.reduce(acc, fn [p1, p2], acc ->
        {dx, dy} = distance(p1, p2)

        antinodes_until_edge(p1, p2, dx, dy, max_x, max_y, [p1, p2])
        |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or x > max_x or y > max_y end)
        |> Enum.into(acc)
      end)
    end)
    |> MapSet.size()
  end

  def distance({x1, y1}, {x2, y2}), do: {x2 - x1, y2 - y1}
  def antinodes({x1, y1}, {x2, y2}, dx, dy), do: [{x1 - dx, y1 - dy}, {x2 + dx, y2 + dy}]

  def antinodes_until_edge({x1, y1}, {x2, y2}, _dx, _dy, max_x, max_y, acc)
      when (x1 < 0 or x1 > max_x or y1 < 0 or y1 > max_y) and
             (x2 < 0 or x2 > max_x or y2 < 0 or y2 > max_y) do
    acc
  end

  def antinodes_until_edge(p1, p2, dx, dy, max_x, max_y, acc) do
    [p3, p4] = antinodes(p1, p2, dx, dy)
    antinodes_until_edge(p3, p4, dx, dy, max_x, max_y, [p3, p4 | acc])
  end
end
