defmodule AoC.Day06 do
  def part1(input) do
    {grid, start} = parse_input(input)

    max_x = grid |> Enum.max_by(&elem(&1, 0)) |> elem(0)
    max_y = grid |> Enum.max_by(&elem(&1, 1)) |> elem(1)

    grid
    |> walk_grid(start, :up, max_x, max_y, %{start => 1})
    |> length()
  end

  def part2(input) do
    {grid, start} = parse_input(input)

    max_x = grid |> Enum.max_by(&elem(&1, 0)) |> elem(0)
    max_y = grid |> Enum.max_by(&elem(&1, 1)) |> elem(1)

    grid
    # only consider points that were visited in the first part
    |> walk_grid(start, :up, max_x, max_y, %{start => 1})
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn pos ->
      grid
      |> MapSet.delete(pos)
      |> walk_grid(start, :up, max_x, max_y, %{start => 1})
    end)
    |> Flow.reject(& &1)
    |> Enum.count()
  end

  def walk_grid(grid, pos, dir, max_x, max_y, visited) do
    next = {x, y} = next_pos(pos, dir)

    cond do
      MapSet.member?(grid, next) ->
        walk_grid(grid, next, dir, max_x, max_y, Map.update(visited, next, 1, &(&1 + 1)))

      x < 0 or y < 0 or x > max_x or y > max_y ->
        Map.keys(visited)

      # 4 iterations seems to be safe
      visited |> Map.values() |> Enum.any?(&(&1 > 4)) ->
        false

      true ->
        walk_grid(grid, pos, turn(dir), max_x, max_y, visited)
    end
  end

  def turn(:up), do: :right
  def turn(:right), do: :down
  def turn(:down), do: :left
  def turn(:left), do: :up

  def next_pos({x, y}, :up), do: {x, y - 1}
  def next_pos({x, y}, :right), do: {x + 1, y}
  def next_pos({x, y}, :down), do: {x, y + 1}
  def next_pos({x, y}, :left), do: {x - 1, y}

  def parse_input(input) do
    {grid, _, _, start} =
      input
      |> String.codepoints()
      |> Enum.reduce({MapSet.new(), 0, 0, nil}, fn c, {acc, x, y, start} ->
        case c do
          "\n" -> {acc, 0, y + 1, start}
          "^" -> {MapSet.put(acc, {x, y}), x + 1, y, {x, y}}
          "." -> {MapSet.put(acc, {x, y}), x + 1, y, start}
          _ -> {acc, x + 1, y, start}
        end
      end)

    {grid, start}
  end
end
