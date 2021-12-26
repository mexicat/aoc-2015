defmodule AdventOfCode.Day05 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.filter(fn str ->
      String.match?(str, ~r"[aeiou].*[aeiou].*[aeiou]") and
        String.match?(str, ~r"(.)\1") and
        not String.match?(str, ~r"ab|cd|pq|xy")
    end)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.filter(fn str ->
      String.match?(str, ~r"(..).*\1") and String.match?(str, ~r"(.).\1")
    end)
    |> Enum.count()
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true)
  end
end
