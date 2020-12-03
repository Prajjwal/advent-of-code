input = File.read!(hd System.argv)
        |> String.split("\n")
        |> Enum.take_while(&(String.length(&1) > 0))
        |> Enum.map(&String.graphemes/1)
        |> Enum.map(&List.to_tuple/1)
        |> List.to_tuple

defmodule Toboggan do
  @world input
  @max_x tuple_size(elem(@world, 0))
  @max_y tuple_size(@world)

  defstruct step_x: nil, step_y: nil

  def path(toboggan = %Toboggan{}) do
    # The path taken by the toboggan is a stream of coordinates that wrap around
    # when the x axis is crossed.
    coords = Stream.unfold { 0, 0 }, fn
      { x, y } -> {
          { x, y },
          { rem(x + toboggan.step_x, @max_x), y + toboggan.step_y }
      }
    end

    # The stream should end when we cross the y-axis.
    coords |> Stream.take_while(fn { _, y } -> y < @max_y end)
  end

  def trees_encountered(toboggan = %Toboggan{}) do
    path(toboggan)
    |> Stream.filter(&tree_at?/1)
    |> Enum.count
  end

  defp tree_at?({ x, y }) do
    (@world |> elem(y) |> elem(x)) == "#"
  end
end

defmodule Part1 do
  def solve do
    Toboggan.trees_encountered(%Toboggan{ step_x: 3, step_y: 1 })
  end
end

defmodule Part2 do
  def solve do
    [{ 1, 1 }, { 3, 1 }, { 5, 1 }, { 7, 1 }, { 1, 2 }]
      |> Enum.map(fn { x, y } -> %Toboggan { step_x: x, step_y: y } end)
      |> Enum.map(&Toboggan.trees_encountered/1)
      |> Enum.reduce(1, &(&1 * &2))
  end
end

IO.inspect(Part1.solve)
IO.inspect(Part2.solve)
