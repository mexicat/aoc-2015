defmodule AdventOfCode.Day10 do
  def part1(input) do
    input
    |> parse_input()
    |> evolve(40)
    |> length()
  end

  def part2(input) do
    input
    |> parse_input()
    # fast enough
    |> evolve(50)
    |> length()
  end

  def evolve(seq, 0), do: seq

  def evolve(seq, n) do
    seq
    |> Enum.chunk_by(& &1)
    |> Enum.flat_map(fn digits ->
      List.flatten([digits |> length() |> Integer.digits(), hd(digits)])
    end)
    |> evolve(n - 1)
  end

  def parse_input(input) do
    input |> String.trim() |> String.to_integer() |> Integer.digits()
  end
end
