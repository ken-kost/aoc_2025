defmodule Aoc2025.Solutions.Y25.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> then(fn [ranges, numbers] ->
      ranges =
        ranges
        |> String.split("\n")
        |> Enum.map(fn range ->
          [a, b] = String.split(range, "-")
          String.to_integer(a)..String.to_integer(b)
        end)

      numbers =
        numbers
        |> String.split("\n")
        |> Enum.map(&String.to_integer(&1))

      {ranges, numbers}
    end)
  end

  def part_one({ranges, numbers}) do
    numbers
    |> Enum.reduce(0, fn number, acc ->
      if Enum.any?(ranges, fn range -> number in range end) do
        acc + 1
      else
        acc
      end
    end)
  end

  def part_two({ranges, _numbers}) do
    ranges
    |> Enum.map(&{&1.first, &1.last})
    |> Enum.sort()
    |> then(&merge_sorted/1)
    |> Enum.map(fn {a, b} -> b - a + 1 end)
    |> Enum.sum()
  end

  defp merge_sorted([]), do: []
  defp merge_sorted([interval]), do: [interval]

  defp merge_sorted([{a, b}, {c, d} | rest]) when b + 1 >= c do
    merge_sorted([{a, max(b, d)} | rest])
  end

  defp merge_sorted([h | t]), do: [h | merge_sorted(t)]
end
