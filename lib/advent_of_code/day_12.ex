defmodule AdventOfCode.Day12 do
  def part1(input) do
    json = parse_input(input)

    Regex.scan(~r/-?\d*\d+/, json)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part2(input) do
    input |> parse_input() |> Jason.decode!() |> sum_redless()
  end

  def sum_redless(n) when is_number(n), do: n

  def sum_redless(json) when is_list(json) do
    Enum.reduce(json, 0, fn x, acc ->
      sum_redless(x) + acc
    end)
  end

  def sum_redless(json) when is_map(json) do
    if "red" in Map.values(json) do
      0
    else
      Enum.reduce(Map.values(json), 0, fn x, acc ->
        sum_redless(x) + acc
      end)
    end
  end

  def sum_redless(_), do: 0

  def parse_input(input) do
    input |> String.trim()
  end
end
