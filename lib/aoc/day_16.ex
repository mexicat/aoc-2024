defmodule AoC.Day16 do
  def part1(input) do
    {grid, max_x, max_y} = input |> AoC.Grid.parse_grid_to_mapset(["#"])

    g = make_graph(grid)

    start = {:E, {1, max_y - 1}}
    goal = {:N, {max_x - 1, 1}}

    g
    |> Graph.get_shortest_path(start, goal)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [a, b], acc -> Graph.edge(g, a, b).weight + acc end)
  end

  def part2(input) do
    {grid, max_x, max_y} = input |> AoC.Grid.parse_grid_to_mapset(["#"])

    g = make_graph(grid)

    start = {:E, {1, max_y - 1}}
    goal = {:N, {max_x - 1, 1}}

    min =
      Graph.get_shortest_path(g, start, goal)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(0, fn [a, b], acc -> Graph.edge(g, a, b).weight + acc end)

    l = length(Graph.vertices(g))

    g
    |> Graph.vertices()
    |> Enum.with_index()
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.filter(fn {v, i} ->
      IO.inspect("#{i} / #{l}")

      (Graph.get_shortest_path(g, start, v) ++ tl(Graph.get_shortest_path(g, v, goal)))
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(0, fn [a, b], acc ->
        case Graph.edge(g, a, b) do
          nil -> acc + 99999
          x -> x.weight + acc
        end
      end) == min
    end)
    |> Enum.map(fn {{_, v}, _} -> v end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def make_graph(grid) do
    grid
    |> Enum.reduce(Graph.new(type: :undirected), fn {x, y}, acc ->
      [{:S, 0, -1}, {:N, 0, 1}, {:W, -1, 0}, {:E, 1, 0}]
      |> Enum.map(fn {dir, dx, dy} ->
        nb = {x + dx, y + dy}
        {dir, nb, MapSet.member?(grid, nb)}
      end)
      |> Enum.filter(fn {_, _, v} -> v end)
      |> Enum.reduce(acc, fn {dir, nb, _}, acc ->
        Graph.add_edge(acc, {dir, {x, y}}, {dir, nb}, weight: 1)
      end)
      |> Graph.add_edge({:S, {x, y}}, {:W, {x, y}}, weight: 1000)
      |> Graph.add_edge({:W, {x, y}}, {:N, {x, y}}, weight: 1000)
      |> Graph.add_edge({:N, {x, y}}, {:E, {x, y}}, weight: 1000)
      |> Graph.add_edge({:E, {x, y}}, {:S, {x, y}}, weight: 1000)
    end)
  end
end
