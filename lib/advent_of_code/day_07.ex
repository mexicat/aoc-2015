defmodule AdventOfCode.Day07 do
  use Bitwise
  use Agent

  def start_link(circuit) do
    Agent.start_link(fn -> {circuit, %{}} end, name: __MODULE__)
  end

  def part1(input) do
    circuit = parse_input(input)
    start_link(circuit)
    run(circuit)
    Agent.get(__MODULE__, & &1) |> elem(1) |> Map.get(:a)
  end

  def part2(input) do
    circuit = parse_input(input)
    start_link(circuit)
    run(circuit)

    Agent.update(__MODULE__, fn {circuit, signals} ->
      a = Map.get(signals, :a)
      {circuit, %{b: a}}
    end)

    run(circuit)
    Agent.get(__MODULE__, & &1) |> elem(1) |> Map.get(:a)
  end

  def run(circuit), do: Enum.each(circuit, &op/1)

  def op({[a], wire}), do: set(wire, get(a))
  def op({[:NOT, a], _wire}), do: ~~~get(a) &&& 0xFFFF
  def op({[a, :AND, b], _wire}), do: get(a) &&& get(b)
  def op({[a, :OR, b], _wire}), do: get(a) ||| get(b)
  def op({[a, :LSHIFT, b], _wire}), do: get(a) <<< get(b)
  def op({[a, :RSHIFT, b], _wire}), do: get(a) >>> get(b)

  def get(n) when is_integer(n), do: n

  def get(wire) when is_atom(wire) do
    case Agent.get(__MODULE__, fn {_, signals} -> Map.get(signals, wire) end) do
      nil ->
        Agent.get(__MODULE__, fn {c, _s} ->
          Enum.find(c, fn {_, x} -> x == wire end)
        end)
        |> op()
        |> then(fn val -> set(wire, val) end)

      x ->
        x
    end
  end

  def set(wire, val) do
    Agent.update(__MODULE__, fn {circuit, signals} ->
      {circuit, Map.put(signals, wire, val)}
    end)

    val
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line, " -> ")

      a =
        a
        |> String.split()
        |> Enum.map(fn symbol ->
          case Integer.parse(symbol) do
            {n, _} -> n
            :error -> String.to_atom(symbol)
          end
        end)

      {a, String.to_atom(b)}
    end)
  end
end
