defmodule Aoc2025.Solutions.Y25.Day04 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        case char do
          "." -> {{x, y}, false}
          "@" -> {{x, y}, true}
        end
      end)
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  def part_one(problem) do
    list = Map.to_list(problem)
    {_new_problem, acc} = find_roles_of_paper(list, problem, 0, %{})
    acc
  end

  def part_two(problem, acc \\ 0) do
    list = Map.to_list(problem)
    {new_problem, new_acc} = find_roles_of_paper(list, problem, acc, %{})
    if new_problem == problem, do: new_acc, else: part_two(new_problem, new_acc)
  end

  defp find_roles_of_paper([], _problem, acc, new_problem), do: {new_problem, acc}

  defp find_roles_of_paper([{{x, y}, is_paper} | rest], problem, acc, new_problem) do
    condition = is_paper and less_than_four_neighbors?(x, y, problem)
    acc = if condition, do: acc + 1, else: acc
    is_paper = not condition and is_paper
    new_problem = Map.put(new_problem, {x, y}, is_paper)
    find_roles_of_paper(rest, problem, acc, new_problem)
  end

  defp less_than_four_neighbors?(x, y, problem) do
    Enum.zip([-1, 1, 0, 0, -1, 1, -1, 1], [0, 0, -1, 1, -1, -1, 1, 1])
    |> Enum.map(fn {x_diff, y_diff} -> {x + x_diff, y + y_diff} end)
    |> Enum.filter(fn {x, y} -> Map.get(problem, {x, y}, false) end)
    |> length() < 4
  end
end
