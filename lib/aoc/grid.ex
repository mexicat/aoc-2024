defmodule AoC.Grid do
  @type mapgrid() :: %{{non_neg_integer(), non_neg_integer()} => atom()}
  @type mapsetgrid() :: MapSet.t({non_neg_integer(), non_neg_integer()})

  @dirs [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]

  @spec parse_grid_to_map(String.t(), [String.t(), ...] | []) ::
          {mapgrid(), non_neg_integer(), non_neg_integer()}
  def parse_grid_to_map(input, exclude \\ [], cast \\ &String.to_atom/1) do
    {grid, max_x, max_y} =
      input
      |> String.trim()
      |> String.codepoints()
      |> Enum.reduce({%{}, 0, 0}, fn c, {acc, x, y} ->
        cond do
          c == "\n" -> {acc, 0, y + 1}
          c not in exclude -> {Map.put(acc, {x, y}, cast.(c)), x + 1, y}
          true -> {acc, x + 1, y}
        end
      end)

    {grid, max_x - 1, max_y}
  end

  @spec parse_grid_to_mapset(String.t()) :: {mapsetgrid(), non_neg_integer(), non_neg_integer()}
  def parse_grid_to_mapset(input, exclude \\ []) do
    {grid, max_x, max_y} =
      input
      |> String.codepoints()
      |> Enum.reduce({MapSet.new(), 0, 0}, fn c, {acc, x, y} ->
        cond do
          c == "\n" -> {acc, 0, y + 1}
          c not in exclude -> {MapSet.put(acc, {x, y}), x + 1, y}
          true -> {acc, x + 1, y}
        end
      end)
      |> elem(0)

    {grid, max_x - 1, max_y}
  end

  def neighbors(grid, {x, y}) do
    @dirs
    |> Enum.map(fn {dx, dy} ->
      nb = {x + dx, y + dy}
      {nb, Map.get(grid, nb)}
    end)
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
  end

  @spec visualize(mapgrid()) :: mapgrid()
  def visualize(grid, max_x \\ nil, max_y \\ nil) when is_map(grid) do
    max_x = max_x || grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = max_y || grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for y <- 0..max_y do
      for x <- 0..max_x do
        Map.get(grid, {x, y}, ".")
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()

    grid
  end
end
