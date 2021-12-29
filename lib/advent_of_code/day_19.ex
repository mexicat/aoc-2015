defmodule AdventOfCode.Day19 do
  def part1(input) do
    {replacements, molecule} = parse_input(input)

    # this part could be done with regexes but i think that's gonna bite me in part 2,
    # so i will write a "proper" version
    generate(molecule, [], MapSet.new(), replacements)
    |> Enum.count()
  end

  def part2(input) do
    {replacements, molecule} = parse_input_2(input)

    # so that was for nothing :(
    # oh well
    replacements = Enum.sort_by(replacements, fn {k, _} -> String.length(k) end, &>=/2)
    fabricate(molecule, replacements, 0)
  end

  def generate([a], acc, molecules, replacements) do
    cond do
      [a] in Map.keys(replacements) ->
        replacements
        |> Map.get([a])
        |> Enum.map(fn repl -> acc ++ repl end)
        |> MapSet.new()
        |> MapSet.union(molecules)

      true ->
        molecules
    end
  end

  def generate([a, b | rest], acc, molecules, replacements) do
    new_molecules =
      cond do
        [a, b] in Map.keys(replacements) ->
          replacements
          |> Map.get([a, b])
          |> Enum.map(fn repl -> acc ++ repl ++ rest end)
          |> MapSet.new()
          |> MapSet.union(molecules)

        [a] in Map.keys(replacements) ->
          replacements
          |> Map.get([a])
          |> Enum.map(fn repl -> acc ++ repl ++ [b | rest] end)
          |> MapSet.new()
          |> MapSet.union(molecules)

        true ->
          molecules
      end

    generate([b | rest], acc ++ [a], new_molecules, replacements)
  end

  def fabricate(molecule, replacements, n) do
    to_replace =
      Enum.reduce_while(replacements, nil, fn {from, to}, _ ->
        case String.contains?(molecule, from) do
          true -> {:halt, {from, to}}
          false -> {:cont, nil}
        end
      end)

    case to_replace do
      nil ->
        {molecule, n}

      {from, to} ->
        molecule |> String.replace(from, to, global: false) |> fabricate(replacements, n + 1)
    end
  end

  def parse_input(input) do
    [replacements, molecule] = String.split(input, "\n\n", trim: true)

    replacements =
      replacements
      |> String.split("\n")
      |> Enum.reduce(%{}, fn line, acc ->
        [from, to] = line |> String.split(" => ") |> Enum.map(&String.to_charlist/1)
        Map.update(acc, from, [to], fn val -> [to | val] end)
      end)
      |> Map.new()

    molecule = molecule |> String.trim() |> String.to_charlist()

    {replacements, molecule}
  end

  def parse_input_2(input) do
    [replacements, molecule] = String.split(input, "\n\n", trim: true)

    replacements =
      replacements
      |> String.split("\n")
      |> Enum.map(fn line ->
        [from, to] = line |> String.split(" => ")
        {to, from}
      end)

    {replacements, String.trim(molecule)}
  end
end
