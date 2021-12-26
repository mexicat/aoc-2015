defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce(MapSet.new(), fn instr, grid ->
      {f, [{x1, y1}, {x2, y2}]} = parse_instr(instr)

      Enum.reduce(for(x <- x1..x2, y <- y1..y2, do: {x, y}), grid, fn point, acc ->
        f.(acc, point)
      end)
    end)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.reduce(%{}, fn instr, grid ->
      {f, [{x1, y1}, {x2, y2}]} = actual_parse_instr(instr)

      Enum.reduce(for(x <- x1..x2, y <- y1..y2, do: {x, y}), grid, fn point, acc ->
        f.(acc, point)
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def turn_on(grid, point), do: MapSet.put(grid, point)
  def turn_off(grid, point), do: MapSet.delete(grid, point)

  def toggle(grid, point) do
    if point in grid do
      turn_off(grid, point)
    else
      turn_on(grid, point)
    end
  end

  def actual_turn_on(grid, point), do: Map.update(grid, point, 1, &(&1 + 1))
  def actual_turn_off(grid, point), do: Map.update(grid, point, 0, fn v -> max(v - 1, 0) end)
  def actual_toggle(grid, point), do: Map.update(grid, point, 2, &(&1 + 2))

  def actual_parse_instr(instr) do
    case instr do
      "turn on " <> rest -> {&actual_turn_on/2, parse_range(rest)}
      "turn off " <> rest -> {&actual_turn_off/2, parse_range(rest)}
      "toggle " <> rest -> {&actual_toggle/2, parse_range(rest)}
    end
  end

  def parse_instr(instr) do
    case instr do
      "turn on " <> rest -> {&turn_on/2, parse_range(rest)}
      "turn off " <> rest -> {&turn_off/2, parse_range(rest)}
      "toggle " <> rest -> {&toggle/2, parse_range(rest)}
    end
  end

  def parse_range(range) do
    range
    |> String.split(" through ")
    |> Enum.map(fn r ->
      [x, y] = String.split(r, ",")
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true)
  end
end
