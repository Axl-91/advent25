defmodule Day4 do
  def in_bounds?(matrix, i, j) do
    i >= 0 and j >= 0 and
      i < length(matrix) and
      j < length(List.first(matrix))
  end

  def neighbors(matrix, i, j) do
    offsets = [
      {-1, -1},
      {-1, 0},
      {-1, 1},
      {0, -1},
      {0, 1},
      {1, -1},
      {1, 0},
      {1, 1}
    ]

    for {di, dj} <- offsets,
        in_bounds?(matrix, i + di, j + dj) do
      matrix |> Enum.at(i + di) |> Enum.at(j + dj)
    end
  end

  def count_at(matrix, i, j) do
    neighbors(matrix, i, j)
    |> Enum.count(fn a -> a == "@" end)
  end

  def can_be_accessed?(matrix, i, j) do
    value = matrix |> Enum.at(i) |> Enum.at(j)

    if value != "." and count_at(matrix, i, j) < 4 do
      1
    else
      0
    end
  end

  def part1 do
    file = File.read!("input")

    matrix =
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    rows = length(matrix) - 1
    cols = length(List.first(matrix)) - 1

    for i <- 0..rows do
      for j <- 0..cols do
        can_be_accessed?(matrix, i, j)
      end
    end
    |> Enum.sum_by(fn a -> Enum.sum(a) end)
  end
end
