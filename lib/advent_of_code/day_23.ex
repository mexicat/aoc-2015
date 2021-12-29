defmodule AdventOfCode.Day23 do
  def part1(input) do
    input |> parse_input() |> run(0, %{a: 0, b: 0})
  end

  def part2(input) do
    input |> parse_input() |> run(0, %{a: 1, b: 0})
  end

  def run(ops, i, reg) do
    ops
    |> Enum.at(i)
    |> case do
      {:hlf, r} ->
        run(ops, i + 1, Map.update!(reg, r, &div(&1, 2)))

      {:tpl, r} ->
        run(ops, i + 1, Map.update!(reg, r, &(&1 * 3)))

      {:inc, r} ->
        run(ops, i + 1, Map.update!(reg, r, &(&1 + 1)))

      {:jmp, o} ->
        run(ops, i + o, reg)

      {:jie, r, o} ->
        if rem(reg[r], 2) === 0, do: run(ops, i + o, reg), else: run(ops, i + 1, reg)

      {:jio, r, o} ->
        if reg[r] === 1, do: run(ops, i + o, reg), else: run(ops, i + 1, reg)

      nil ->
        reg
    end
  end

  def parse_input(input) do
    input
    |> String.replace(",", "")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {n, _} -> n
          :error -> String.to_atom(x)
        end
      end)
      |> List.to_tuple()
    end)
  end
end
