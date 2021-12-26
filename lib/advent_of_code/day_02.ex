defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn [x, y, z] -> 3 * x * y + 2 * y * z + 2 * z * x end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn [x, y, z] -> x * 2 + y * 2 + x * y * z end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn size ->
      size |> String.split("x") |> Enum.map(&String.to_integer/1) |> Enum.sort()
    end)
  end
end
