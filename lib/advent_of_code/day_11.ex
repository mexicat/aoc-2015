defmodule AdventOfCode.Day11 do
  @forbidden [?i, ?o, ?l]
  def part1(input) do
    input |> parse_input() |> find_next()
  end

  def part2(input) do
    input |> parse_input() |> find_next() |> find_next()
  end

  def find_next(password) do
    Enum.reduce_while(Stream.cycle([true]), password, fn _, acc ->
      password = increment(acc)

      if is_valid?(password) do
        {:halt, password}
      else
        {:cont, password}
      end
    end)
  end

  def increment(password) do
    password
    |> Enum.reverse()
    |> do_increment([], true)
  end

  def do_increment([], acc, false), do: acc
  def do_increment([?z | rest], acc, true), do: do_increment(rest, [?a | acc], true)
  def do_increment([x | rest], acc, true), do: do_increment(rest, [x + 1 | acc], false)
  def do_increment([x | rest], acc, false), do: do_increment(rest, [x | acc], false)

  def is_valid?(password) do
    no_forbidden_letters?(password) and
      has_pairs?(password) and
      has_straight?(password)
  end

  def no_forbidden_letters?(password) do
    not Enum.any?(password, fn x -> x in @forbidden end)
  end

  def has_pairs?(password) do
    password
    |> Enum.chunk_by(& &1)
    |> Enum.count(fn x -> length(x) >= 2 end)
    |> Kernel.>=(2)
  end

  def has_straight?(password) do
    password
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.any?(fn [a, b, c] ->
      b == a + 1 and c == b + 1
    end)
  end

  def parse_input(input) do
    input |> String.trim() |> String.to_charlist()
  end
end
