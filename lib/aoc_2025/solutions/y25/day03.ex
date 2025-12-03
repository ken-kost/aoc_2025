defmodule Aoc2025.Solutions.Y25.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  def part_one(problem) do
    problem
    |> find_max_joltages(2, [])
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> find_max_joltages(12, [])
    |> Enum.sum()
  end

  defp find_max_joltages([], _n, acc), do: acc

  defp find_max_joltages([head | rest], n, acc) do
    find_max_joltages(rest, n, [find_max_joltage(head, n) | acc])
  end

  defp find_max_joltage(batteries, n) do
    pick_n_greedy(batteries, n, [])
    |> Enum.join("")
    |> String.to_integer()
  end

  defp pick_n_greedy(_batteries, 0, acc), do: Enum.reverse(acc)

  defp pick_n_greedy(batteries, n, acc) do
    available_count = length(batteries) - n + 1

    {best_val, best_idx} =
      batteries
      |> Enum.take(available_count)
      |> Enum.with_index()
      |> Enum.max_by(fn {val, _idx} -> val end)

    remaining = Enum.drop(batteries, best_idx + 1)
    pick_n_greedy(remaining, n - 1, [best_val | acc])
  end
end
