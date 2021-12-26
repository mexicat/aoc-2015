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

  def op({[a], wire}) do
    set(wire, value(a))
    value(a)
  end

  def op({[:NOT, a], _wire}), do: ~~~value(a) &&& 0xFFFF
  def op({[a, :AND, b], _wire}), do: value(a) &&& value(b)
  def op({[a, :OR, b], _wire}), do: value(a) ||| value(b)
  def op({[a, :LSHIFT, b], _wire}), do: value(a) <<< value(b)
  def op({[a, :RSHIFT, b], _wire}), do: value(a) >>> value(b)

  def value(n) when is_integer(n), do: n

  def value(wire) when is_atom(wire) do
    val =
      case Agent.get(__MODULE__, fn {_, signals} -> Map.get(signals, wire) end) do
        nil ->
          Agent.get(__MODULE__, fn {c, _s} -> c end)
          |> Enum.find(fn {_, c} -> c == wire end)
          |> op()

        x ->
          x
      end

    set(wire, val)
    val
  end

  def set(wire, val) do
    Agent.update(__MODULE__, fn {circuit, signals} ->
      {circuit, Map.put(signals, wire, val)}
    end)
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
