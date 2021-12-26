defmodule AdventOfCode.Day08 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn s ->
      {a, b} = {s |> Code.eval_string() |> elem(0), String.codepoints(s)}
      length(b) - String.length(a)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn s ->
      {a, b} = {Kernel.inspect(s), String.codepoints(s)}
      String.length(a) - length(b)
    end)
    |> Enum.sum()
  end

  def parse_input(input) do
    String.split(input, "\n", trim: true)
  end
end
