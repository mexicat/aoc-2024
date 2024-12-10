defmodule AoC.Day09 do
  def part1(input) do
    blocks = parse_input(input)
    indexes = blocks |> Enum.sort(:desc)

    blocks
    |> defrag_blocks(indexes, 0)
    |> Enum.sort(:desc)
    |> Enum.reduce(0, fn
      {_, nil}, acc -> acc
      {i, x}, acc -> acc + i * x
    end)
  end

  def defrag_blocks(blocks, [{i, _} | _], first_nil) when i < first_nil, do: blocks

  def defrag_blocks(blocks, [{_, nil} | rest], first_nil),
    do: defrag_blocks(blocks, rest, first_nil)

  def defrag_blocks(blocks, [{i, val} | rest] = acc, first_nil) do
    case Map.get(blocks, first_nil) do
      nil ->
        blocks
        |> Map.put(i, nil)
        |> Map.put(first_nil, val)
        |> defrag_blocks(rest, first_nil + 1)

      _ ->
        defrag_blocks(blocks, acc, first_nil + 1)
    end
  end

  def part2(input) do
    blocks = parse_input(input)

    indexes =
      blocks
      |> Enum.group_by(fn {_, v} -> v end, fn {k, _} -> k end)
      |> Enum.reject(fn {k, _} -> is_nil(k) end)
      |> Enum.sort(:desc)

    blocks
    |> defrag_whole_files(indexes, 0)
    |> Enum.reduce(0, fn
      {_, nil}, acc -> acc
      {i, x}, acc -> acc + i * x
    end)
  end

  def defrag_whole_files(blocks, [], _), do: blocks

  def defrag_whole_files(blocks, [{i, to_move} | rest], first_nil) do
    to_move_count = length(to_move)

    {nil_indexes, first_nil} =
      Enum.reduce_while(first_nil..map_size(blocks), {[], nil}, fn
        _, {acc, first_nil} when length(acc) == to_move_count ->
          {:halt, {acc, first_nil}}

        j, {acc, first_nil} ->
          case Map.get(blocks, j) do
            nil -> {:cont, {[j | acc], if(is_nil(first_nil), do: j, else: first_nil)}}
            _ -> {:cont, {[], first_nil}}
          end
      end)

    cond do
      length(nil_indexes) < to_move_count ->
        defrag_whole_files(blocks, rest, first_nil)

      Enum.min(to_move) < Enum.min(nil_indexes) ->
        defrag_whole_files(blocks, rest, first_nil)

      true ->
        blocks =
          Enum.reduce(nil_indexes, blocks, fn nil_i, blocks ->
            Map.put(blocks, nil_i, i)
          end)

        blocks =
          Enum.reduce(to_move, blocks, fn from, blocks ->
            Map.put(blocks, from, nil)
          end)

        defrag_whole_files(blocks, rest, first_nil)
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({[], 0, :file}, fn
      n, {acc, id, :file} -> {Enum.concat(List.duplicate(id, n), acc), id + 1, :free}
      n, {acc, id, :free} -> {Enum.concat(List.duplicate(nil, n), acc), id, :file}
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.with_index(fn element, index -> {index, element} end)
    |> Map.new()
  end
end
