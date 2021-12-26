defmodule AdventOfCode.Day17 do
  def part1(input) do
    containers = parse_input(input)

    Enum.reduce(1..length(containers), 0, fn n, acc ->
      containers
      |> combs(n)
      |> Enum.count(fn c -> Enum.sum(c) == 150 end)
      |> Kernel.+(acc)
    end)
  end

  def part2(input) do
    containers = parse_input(input)

    Enum.reduce_while(1..length(containers), 0, fn n, _ ->
      containers
      |> combs(n)
      |> Enum.count(fn c -> Enum.sum(c) == 150 end)
      |> case do
        0 -> {:cont, 0}
        n -> {:halt, n}
      end
    end)
  end

  def combs(_, 0), do: [[]]
  def combs([], _), do: []

  def combs([h | t], m) do
    for(l <- combs(t, m - 1), do: [h | l]) ++ combs(t, m)
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
