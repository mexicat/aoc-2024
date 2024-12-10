defmodule AoC.Day10 do
  def part1(input) do
    {grid, _, _} = input |> AoC.Grid.parse_grid_to_map(["."], &String.to_integer/1)

    graph = make_graph(grid)
    starts = Enum.filter(grid, fn {_, v} -> v == 0 end)
    ends = Enum.filter(grid, fn {_, v} -> v == 9 end)

    for s <- starts, e <- ends, path = Graph.get_shortest_path(graph, s, e), path, reduce: 0 do
      acc -> acc + 1
    end
  end

  def part2(input) do
    {grid, _, _} = input |> AoC.Grid.parse_grid_to_map(["."], &String.to_integer/1)

    graph = make_graph(grid)
    starts = Enum.filter(grid, fn {_, v} -> v == 0 end)
    ends = Enum.filter(grid, fn {_, v} -> v == 9 end)

    for s <- starts, e <- ends, score = graph |> Graph.get_paths(s, e) |> length(), reduce: 0 do
      acc -> acc + score
    end
  end

  def make_graph(grid) do
    Enum.reduce(grid, Graph.new(), fn {k, v}, acc ->
      grid
      |> AoC.Grid.neighbors(k)
      |> Enum.filter(fn {_, v1} -> v1 - v == 1 end)
      |> Enum.reduce(acc, fn nb, acc -> Graph.add_edge(acc, {k, v}, nb) end)
    end)
  end
end
