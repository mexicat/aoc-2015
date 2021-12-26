defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> parse_input()
    |> visit()
    |> Enum.count()
  end

  def part2(input) do
    dirs = parse_input(input)
    santa = Enum.take_every(dirs, 2)
    robot = Enum.take_every(Enum.drop(dirs, 1), 2)

    MapSet.union(visit(santa), visit(robot)) |> Enum.count()
  end

  def visit(dirs, point \\ {0, 0}, visited \\ MapSet.new())

  def visit([], _, visited), do: visited

  def visit([curr | rest], point, visited) do
    visit(rest, go(point, curr), MapSet.put(visited, point))
  end

  def go({x, y}, "^"), do: {x, y + 1}
  def go({x, y}, "v"), do: {x, y - 1}
  def go({x, y}, "<"), do: {x - 1, y}
  def go({x, y}, ">"), do: {x + 1, y}

  def parse_input(input) do
    input |> String.trim() |> String.codepoints()
  end
end
