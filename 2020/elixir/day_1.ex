input = File.stream!(hd System.argv)
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(fn { i, "\n" } -> i end)
        |> Enum.sort

pairs = Stream.flat_map input, fn i ->
  Stream.flat_map input, fn j ->
    [{ i, j }]
  end
end

triplets = Stream.flat_map pairs, fn { i, j } ->
  Stream.flat_map input, fn k ->
    [{ i, j, k }]
  end
end

[{ a, b }] = pairs
          |> Stream.filter(fn { i, j } -> i < j end)
          |> Stream.filter(fn { i, j } -> i + j == 2020 end)
          |> Enum.take(1)

IO.inspect(a * b)

[{ a, b, c }] = triplets
              |> Stream.filter(fn { i, j, k } -> i + j + k == 2020 end)
              |> Enum.take(1)

IO.inspect(a * b * c)
