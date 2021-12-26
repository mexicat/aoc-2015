defmodule AdventOfCode.Day14 do
  def part1(input) do
    input
    |> parse_input()
    |> pass_seconds(2503)
    |> Enum.max_by(fn r -> r.run end)
    |> Map.get(:run)
  end

  def part2(input) do
    input
    |> parse_input()
    |> pass_seconds_and_score(2503)
    |> Enum.max_by(fn r -> r.score end)
    |> Map.get(:score)
  end

  def pass_seconds(reindeers, 0), do: reindeers

  def pass_seconds(reindeers, n) do
    reindeers
    |> Enum.map(&advance/1)
    |> pass_seconds(n - 1)
  end

  def pass_seconds_and_score(reindeers, 0), do: reindeers

  def pass_seconds_and_score(reindeers, n) do
    advanced = Enum.map(reindeers, &advance/1)
    winning = Enum.max_by(advanced, fn r -> r.run end)
    advanced = List.delete(advanced, winning)
    winning = %{winning | score: winning.score + 1}

    pass_seconds_and_score([winning | advanced], n - 1)
  end

  def advance(r = %{stamina_left: 1}) do
    %{r | run: r.run + r.speed, stamina_left: 0, rest_left: r.rest}
  end

  def advance(r = %{stamina_left: stamina_left}) when stamina_left > 0 do
    %{r | run: r.run + r.speed, stamina_left: stamina_left - 1}
  end

  def advance(r = %{rest_left: 1}) do
    %{r | rest_left: 0, stamina_left: r.stamina}
  end

  def advance(r = %{rest_left: rest_left}) when rest_left > 0 do
    %{r | rest_left: rest_left - 1}
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [name, speed, stamina, rest] =
        String.split(
          line,
          [
            " can fly ",
            " km/s for ",
            " seconds, but then must rest for ",
            " seconds."
          ],
          trim: true
        )

      %{
        name: name,
        speed: String.to_integer(speed),
        stamina: String.to_integer(stamina),
        rest: String.to_integer(rest),
        rest_left: 0,
        stamina_left: String.to_integer(stamina),
        run: 0,
        score: 0
      }
    end)
  end
end
