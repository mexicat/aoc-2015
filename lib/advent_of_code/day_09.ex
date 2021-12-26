defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> parse_input()
    |> make_graph()
    |> score_paths()
    |> Enum.min()
  end

  def part2(input) do
    input
    |> parse_input()
    |> make_graph()
    |> score_paths()
    |> Enum.max()
  end

  def make_graph(lines) do
    Enum.reduce(lines, Graph.new(), fn {from, to, dist}, acc ->
      acc |> Graph.add_edge(from, to, weight: dist) |> Graph.add_edge(to, from, weight: dist)
    end)
  end

  def score_paths(graph) do
    vertices = Graph.vertices(graph)

    vertices
    |> Enum.flat_map(fn v ->
      other_vertices = List.delete(vertices, v)

      Enum.flat_map(other_vertices, fn ov ->
        graph |> Graph.get_paths(v, ov) |> Enum.reject(fn p -> length(p) < length(vertices) end)
      end)
    end)
    |> Enum.map(fn path ->
      path
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(0, fn [from, to], acc ->
        Graph.edge(graph, from, to).weight + acc
      end)
    end)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b, c] = String.split(line, [" to ", " = "])
      {a, b, String.to_integer(c)}
    end)
  end
end
