defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> parse_input()
    |> find_n("00000")
  end

  def part2(input) do
    input
    |> parse_input()
    |> find_n("000000")
  end

  def find_n(key, match, n \\ 0) do
    :crypto.hash(:md5, "#{key}#{n}")
    |> Base.encode16()
    |> String.slice(0..(String.length(match) - 1))
    |> case do
      ^match -> n
      _ -> find_n(key, match, n + 1)
    end
  end

  def parse_input(input) do
    String.trim(input)
  end
end
