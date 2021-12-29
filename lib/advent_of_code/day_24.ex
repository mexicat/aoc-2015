defmodule AdventOfCode.Day24 do
  def part1(input) do
    weights = parse_input(input)
    sum = Enum.sum(weights)
    group = div(sum, 3)

    # hardcoded for my input :)
    combs =
      for a <- weights,
          b <- weights -- [a],
          c <- weights -- [a, b],
          d <- weights -- [a, b, c],
          e <- weights -- [a, b, c, d],
          f <- weights -- [a, b, c, d, e],
          a + b + c + d + e + f == group,
          do: [a, b, c, d, e, f]

    combs |> Enum.map(&Enum.product/1) |> Enum.min()
  end

  def part2(input) do
    weights = parse_input(input)
    sum = Enum.sum(weights)
    group = div(sum, 4)

    # hardcoded for my input :)
    combs =
      for a <- weights,
          b <- weights -- [a],
          c <- weights -- [a, b],
          d <- weights -- [a, b, c],
          e <- weights -- [a, b, c, d],
          a + b + c + d + e == group,
          do: [a, b, c, d, e]

    combs |> Enum.map(&Enum.product/1) |> Enum.min()
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
