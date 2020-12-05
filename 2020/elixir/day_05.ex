defmodule BoardingPass do
  def converge("F", { low, high }), do: { low, mid(low, high) }
  def converge("B", { low, high }), do: { mid(low, high) + 1, high }
  def converge("L", { low, high }), do: { low, floor((low + high) / 2) }
  def converge("R", { low, high }), do: { (low + high) / 2 + 1, high }

  def converge(code, { low, high }) do
    List.foldl(code, { low, high }, &converge/2)
  end

  def seat(code) do
    { vcode, hcode } = code
                       |> String.graphemes
                       |> Enum.split_while(&(&1 in ["F", "B"]))

    { _, row } = converge(vcode, { 0, 127 })
    { _, col } = converge(hcode, { 0, 7 })

    row * 8 + col
  end

  defp mid(low, high), do: floor((low + high) / 2)
end

seats = File.read!(hd System.argv)
        |> String.split
        |> Enum.map(&BoardingPass.seat/1)
        |> Enum.sort

# Part 1
IO.inspect(Enum.max(seats)) # => 858

# Part 2
result = Enum.reduce_while seats, Enum.min(seats) - 1, fn current, last ->
  if (current - last) == 1, do: { :cont, current }, else: { :halt, last + 1 }
end

IO.inspect(result) # => 557
