defmodule AdventOfCode.Day16 do
  @needed %{
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
  }
  @needed_eq ["children", "samoyeds", "akitas", "vizslas", "cars", "perfumes"]
  @needed_gt ["cats", "trees"]
  @needed_lt ["pomeranians", "goldfish"]

  def part1(input) do
    input
    |> parse_input()
    |> Enum.find(fn {_, attrs} ->
      Enum.all?(attrs, fn {k, v} -> @needed[k] == v end)
    end)
    |> elem(0)
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.find(fn {_, attrs} ->
      Enum.all?(attrs, fn {k, v} ->
        cond do
          k in @needed_eq -> v == @needed[k]
          k in @needed_lt -> v < @needed[k]
          k in @needed_gt -> v > @needed[k]
        end
      end)
    end)
    |> elem(0)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [sue, attrs] = String.split(line, ": ", parts: 2)
      [_, sue] = String.split(sue)

      attrs =
        attrs
        |> String.split(", ")
        |> Enum.map(fn attr ->
          [k, v] = String.split(attr, ": ")
          {k, String.to_integer(v)}
        end)

      Map.put(acc, sue, Map.new(attrs))
    end)
  end
end
