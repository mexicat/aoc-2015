defmodule AdventOfCode.Day25 do
  def part1(input) do
    [row, col] = parse_input(input)

    find_n({1, 1}, {col, row}, 20_151_125)
  end

  def find_n(target, target, n), do: n

  def find_n({x, y}, target, n) do
    new_points = if y == 1, do: {1, x + 1}, else: {x + 1, y - 1}
    n = rem(n * 252_533, 33_554_393)
    find_n(new_points, target, n)
  end

  def parse_input(input) do
    Regex.scan(~r/-?\d*\d+/, input) |> List.flatten() |> Enum.map(&String.to_integer/1)
  end
end
