defmodule AdventOfCode.Day20 do
  def part1(input) do
    input |> parse_input() |> find_house()
  end

  def part2(input) do
    input |> parse_input() |> find_house_2()
  end

  def find_house(target) do
    Stream.unfold(1, fn n ->
      presents = factors(n) |> Enum.sum() |> Kernel.*(10)
      {{n, presents}, n + 1}
    end)
    |> Enum.find(fn {_, presents} -> presents >= target end)
    |> elem(0)
  end

  def find_house_2(target) do
    Stream.unfold(1, fn n ->
      presents =
        factors(n)
        |> Enum.sort()
        |> Enum.drop_while(fn x -> div(n, x) >= 50 end)
        |> Enum.sum()
        |> Kernel.*(11)

      {{n, presents}, n + 1}
    end)
    |> Enum.find(fn {_, presents} -> presents >= target end)
    |> elem(0)
  end

  def factors(n), do: factors(n, 1, [])
  defp factors(n, i, factors) when n < i * i, do: factors
  defp factors(n, i, factors) when n == i * i, do: [i | factors]
  defp factors(n, i, factors) when rem(n, i) == 0, do: factors(n, i + 1, [i, div(n, i) | factors])
  defp factors(n, i, factors), do: factors(n, i + 1, factors)

  def parse_input(input) do
    input |> String.trim() |> String.to_integer()
  end
end
