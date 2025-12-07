defmodule Aoc2025.Solutions.Y25.Day06 do
  alias AoC.Input

  def parse(input, :part_one) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn
        "*" -> fn x, y -> x * y end
        "+" -> fn x, y -> x + y end
        n -> String.to_integer(n)
      end)
    end)
  end

  def parse(input, :part_two) do
    input
    |> Input.read!()
    |> String.split("\n")
    |> Enum.filter(fn x -> x != "" end)
    |> List.pop_at(-1)
  end

  def part_one(problem) do
    {operations, numbers} = List.pop_at(problem, -1)

    column_numbers =
      for col <- 0..(length(operations) - 1) do
        for row <- numbers do
          Enum.at(row, col)
        end
      end

    operations
    |> Enum.zip(column_numbers)
    |> Enum.reduce(0, fn {operation, [head | tail]}, acc ->
      Enum.reduce(tail, head, fn x, y -> operation.(x, y) end) + acc
    end)
  end

  def part_two({operations, numbers}) do
    operations =
      operations
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.filter(fn {x, _} -> x != " " end)
      |> Enum.map(fn {x, i} -> {x, i} end)

    numbers =
      Enum.map(numbers, fn line ->
        line
        |> String.codepoints()
        |> Enum.with_index()
      end)

    operations =
      Enum.map(operations, fn {op, i} ->
        case op do
          "*" -> {fn x, y -> x * y end, i}
          "+" -> {fn x, y -> x + y end, i}
        end
      end)

    calculate(operations, numbers, 0)
  end

  defp calculate([{op, i}], numbers, acc) do
    max = Enum.max(Enum.map(numbers, fn x -> length(x) end))
    column_numbers = get_column_numbers(numbers, i, max, [])
    res = Enum.reduce(column_numbers, fn x, y -> op.(x, y) end)
    res + acc
  end

  defp calculate([{op1, i1}, {op2, i2} | rest], numbers, acc) do
    column_numbers = get_column_numbers(numbers, i1, i2 - 1, [])
    res = Enum.reduce(column_numbers, fn x, y -> op1.(x, y) end)
    calculate([{op2, i2} | rest], numbers, res + acc)
  end

  defp get_column_numbers(_numbers, i, max, acc) when i == max do
    acc
    |> Enum.reverse()
    |> Enum.filter(fn line -> not Enum.all?(line, fn x -> is_nil(x) or elem(x, 0) == " " end) end)
    |> Enum.map(fn line ->
      line
      |> Enum.filter(fn x -> not is_nil(x) and x != " " end)
      |> Enum.map(fn {x, _i} -> x end)
      |> Enum.join("")
      |> String.trim()
      |> String.replace(" ", "")
      |> String.to_integer()
    end)
  end

  defp get_column_numbers(numbers, i, max, acc) do
    column_numbers = Enum.map(numbers, fn x -> Enum.at(x, i) end)
    get_column_numbers(numbers, i + 1, max, [column_numbers | acc])
  end
end
