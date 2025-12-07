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

  def create_matrix(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def get_removed_matrix(matrix) do
    rows = length(matrix) - 1
    cols = length(List.first(matrix)) - 1

    for i <- 0..rows do
      for j <- 0..cols do
        can_be_accessed?(matrix, i, j)
      end
    end
  end

  def part1 do
    file = File.read!("input")

    matrix = create_matrix(file)

    get_removed_matrix(matrix)
    |> Enum.sum_by(fn a -> Enum.sum(a) end)
  end

  def run_reductions_from_matrix(matrix, total_removed) do
    removed = get_removed_matrix(matrix)

    amount_removed = removed |> Enum.sum_by(fn a -> Enum.sum(a) end)

    if amount_removed == 0 do
      total_removed
    else
      matrix
      |> Enum.with_index()
      |> Enum.map(fn {row, row_idx} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {val, val_idx} ->
          if val == "@" and Enum.at(removed, row_idx) |> Enum.at(val_idx) == 1 do
            "."
          else
            val
          end
        end)
      end)
      |> run_reductions_from_matrix(amount_removed + total_removed)
    end
  end

  def part2 do
    file = File.read!("input")

    matrix = create_matrix(file)

    run_reductions_from_matrix(matrix, 0)
  end
end
