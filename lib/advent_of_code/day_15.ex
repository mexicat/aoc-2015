defmodule AdventOfCode.Day15 do
  def part1(input) do
    [x, y, z, w] = parse_input(input)

    setups()
    |> Enum.map(fn [a, b, c, d] ->
      x = x |> Enum.map(fn n -> n * a end)
      y = y |> Enum.map(fn n -> n * b end)
      z = z |> Enum.map(fn n -> n * c end)
      w = w |> Enum.map(fn n -> n * d end)

      [x, y, z, w]
      |> Enum.zip()
      |> Enum.take(4)
      |> Enum.map(fn setup -> setup |> Tuple.to_list() |> Enum.sum() |> max(0) end)
      |> Enum.product()
    end)
    |> Enum.max()
  end

  def part2(input) do
    [x, y, z, w] = parse_input(input)

    setups()
    |> Enum.reduce([], fn [a, b, c, d], acc ->
      x = x |> Enum.map(fn n -> n * a end)
      y = y |> Enum.map(fn n -> n * b end)
      z = z |> Enum.map(fn n -> n * c end)
      w = w |> Enum.map(fn n -> n * d end)

      [calories | attrs] =
        [x, y, z, w]
        |> Enum.zip()
        |> Enum.map(fn setup -> setup |> Tuple.to_list() |> Enum.sum() |> max(0) end)
        |> Enum.reverse()

      case calories do
        500 -> [Enum.product(attrs) | acc]
        _ -> acc
      end
    end)
    |> Enum.max()
  end

  def setups() do
    for a <- 1..100, b <- 1..(100 - a), c <- 1..(100 - a - b) do
      d = 100 - a - b - c
      [a, b, c, d]
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/-?\d*\d+/, line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
