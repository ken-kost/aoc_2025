defmodule Aoc2025.Solutions.Y25.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      case line do
        "L" <> value -> {:left, String.to_integer(value)}
        "R" <> value -> {:right, String.to_integer(value)}
      end
    end)
  end

  def part_one(problem) do
    count_equilibria(problem, 50, 0, _count_passes? = false)
  end

  def part_two(problem) do
    count_equilibria(problem, 50, 0, _count_passes? = true)
  end

  defp count_equilibria([], _, solution, _count_passes?), do: solution

  defp count_equilibria([{direction, value} | rest], current_position, acc, true) do
    case calculate_position_counting_passes(current_position, direction, value) do
      {0, passes} ->
        count_equilibria(rest, 0, acc + passes, true)

      {new_position, passes} ->
        count_equilibria(rest, new_position, acc + passes, true)
    end
  end

  defp count_equilibria([{direction, value} | rest], current_position, acc, false) do
    case calculate_position(current_position, direction, value) do
      0 -> count_equilibria(rest, 0, acc + 1, false)
      new_position -> count_equilibria(rest, new_position, acc, false)
    end
  end

  defp calculate_position(current_position, :left, value) do
    value = rem(value, 100)

    cond do
      value > current_position ->
        100 - (value - current_position)

      true ->
        current_position - value
    end
  end

  defp calculate_position(current_position, :right, value) do
    rem(current_position + value, 100)
  end

  defp calculate_position_counting_passes(current_position, :left, value) do
    {value, passes} = custom_rem(value, 100)

    cond do
      current_position == 0 ->
        {100 - value, passes}

      value > current_position ->
        {100 - (value - current_position), passes + 1}

      true ->
        passes = if current_position - value == 0, do: passes + 1, else: passes
        {current_position - value, passes}
    end
  end

  defp calculate_position_counting_passes(current_position, :right, value) do
    custom_rem(current_position + value, 100)
  end

  defp custom_rem(dividend, divisor) do
    {rem(dividend, divisor), div(dividend, divisor)}
  end
end
