defmodule AoC.Day18 do
  def part1(input) do
    {max_x, max_y} = {70, 70}

    input
    |> parse_input()
    |> Enum.take(1024)
    |> MapSet.new()
    |> make_graph(max_x, max_y)
    |> Graph.get_shortest_path({0, 0}, {max_x, max_y})
    |> length()
    |> Kernel.-(1)
  end

  def part2(input) do
    {max_x, max_y} = {70, 70}
    g = make_graph(MapSet.new(), max_x, max_y)

    res =
      input
      |> parse_input()
      |> Enum.reduce_while(g, fn pos, g ->
        g = Graph.delete_vertex(g, pos)

        case Graph.get_shortest_path(g, {0, 0}, {max_x, max_y}) do
          nil -> {:halt, pos}
          _ -> {:cont, g}
        end
      end)

    "#{elem(res, 0)},#{elem(res, 1)}"
  end

  def make_graph(grid, max_x, max_y) do
    opp_grid =
      for x <- 0..max_x,
          y <- 0..max_y,
          not MapSet.member?(grid, {x, y}),
          do: {x, y},
          into: MapSet.new()

    Enum.reduce(opp_grid, Graph.new(type: :undirected), fn pos, acc ->
      opp_grid
      |> AoC.Grid.neighbors(pos)
      |> Enum.reduce(acc, fn nb, acc -> Graph.add_edge(acc, pos, nb) end)
    end)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
  end
end
