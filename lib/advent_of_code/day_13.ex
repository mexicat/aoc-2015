defmodule AdventOfCode.Day13 do
  def part1(input) do
    prefs = parse_input(input)

    prefs
    |> Map.keys()
    |> perms()
    |> Enum.map(fn people ->
      calc_happiness(people, prefs)
    end)
    |> Enum.max()
  end

  def part2(input) do
    prefs = parse_input(input) |> Map.put("Me", %{})

    prefs
    |> Map.keys()
    |> perms()
    |> Enum.map(fn people ->
      calc_happiness(people, prefs)
    end)
    |> Enum.max()
  end

  def calc_happiness(people, prefs) do
    people
    |> Enum.with_index()
    |> Enum.map(fn {person, i} ->
      left_nb_i = if i == 0, do: length(people) - 1, else: i - 1
      left_nb = Enum.at(people, left_nb_i)
      right_nb_i = if i == length(people) - 1, do: 0, else: i + 1
      right_nb = Enum.at(people, right_nb_i)
      Map.get(prefs[person], left_nb, 0) + Map.get(prefs[person], right_nb, 0)
    end)
    |> Enum.sum()
  end

  def perms([]), do: [[]]

  def perms(list) do
    for h <- list, t <- perms(list -- [h]), do: [h | t]
  end

  def parse_gain("gain " <> n), do: String.to_integer(n)
  def parse_gain("lose " <> n), do: String.to_integer("-#{n}")

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [who, what, where] =
        String.split(line, [" would ", " happiness units by sitting next to ", "."], trim: true)

      gain = parse_gain(what)

      Map.update(acc, who, %{where => gain}, fn m -> Map.put(m, where, gain) end)
    end)
  end
end
