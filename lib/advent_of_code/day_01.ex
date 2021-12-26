defmodule AdventOfCode.Day01 do
  def part1(input) do
    floors = parse_input(input)
    Enum.count(floors, &(&1 == "(")) - Enum.count(floors, &(&1 == ")"))
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.reduce_while({0, 0}, fn go, {pos, floor} ->
      new_floor = if go == "(", do: floor + 1, else: floor - 1

      case new_floor do
        -1 -> {:halt, pos + 1}
        _ -> {:cont, {pos + 1, new_floor}}
      end
    end)
  end

  def parse_input(input) do
    input |> String.trim() |> String.codepoints()
  end
end
