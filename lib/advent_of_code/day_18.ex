defmodule AdventOfCode.Day18 do
  def part1(input) do
    {grid, w, h} = parse_input(input)

    Enum.reduce(1..100, grid, fn _, acc -> animate(acc, w, h) end)
    |> Enum.count()
  end

  def part2(input) do
    {grid, w, h} = parse_input(input)

    Enum.reduce(1..100, patch(grid, w, h), fn _, acc ->
      acc |> animate(w, h) |> patch(w, h)
    end)
    |> Enum.count()
  end

  def animate(grid, w, h) do
    Enum.reduce(for(x <- 0..w, y <- 0..h, do: {x, y}), grid, fn point, acc ->
      case {MapSet.member?(grid, point), on_neighbors(grid, point)} do
        {true, n} when n not in [2, 3] -> MapSet.delete(acc, point)
        {false, 3} -> MapSet.put(acc, point)
        _ -> acc
      end
    end)
  end

  def patch(grid, w, h) do
    grid
    |> MapSet.put({0, 0})
    |> MapSet.put({0, h})
    |> MapSet.put({w, 0})
    |> MapSet.put({w, h})
  end

  def on_neighbors(grid, {x, y}) do
    [
      {x - 1, y},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y},
      {x + 1, y - 1},
      {x + 1, y + 1},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.count(&MapSet.member?(grid, &1))
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    width = String.length(hd(lines)) - 1
    height = length(lines) - 1

    grid =
      for {col, y} <- Enum.with_index(lines),
          {row, x} <- Enum.with_index(String.codepoints(col)),
          row == "#",
          into: MapSet.new() do
        {x, y}
      end

    {grid, width, height}
  end
end
