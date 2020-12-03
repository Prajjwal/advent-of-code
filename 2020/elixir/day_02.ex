# Enterprise Ready lol

defmodule Part1 do
  defmodule Policy do
    defstruct char: nil, min: nil, max: nil
  end

  defmodule Entry do
    defstruct policy: %Policy{}, password: nil

    @matcher ~r/(?<min>\d+)-(?<max>\d+)\s+(?<char>\w): (?<password>\w+)$/

    def parse(input) do
      matches = Regex.named_captures(@matcher, input)

      policy = %Policy{
        char: matches["char"],
        min: String.to_integer(matches["min"]),
        max: String.to_integer(matches["max"])
      }

      %Entry{
        policy: policy,
        password: matches["password"]
      }
    end

    def valid?(entry = %Entry{}) do
      count = char_count(entry.password, entry.policy.char)
      count >= entry.policy.min && count <= entry.policy.max
    end

    defp char_count(str, char) do
      str
      |> String.graphemes
      |> Enum.count(fn c -> c == char end)
    end
  end
end

defmodule Part2 do
  defmodule Policy do
    defstruct char: nil, pos1: nil, pos2: nil
  end

  defmodule Entry do
    defstruct policy: %Policy{}, password: nil

    @matcher ~r/(?<pos1>\d+)-(?<pos2>\d+)\s+(?<char>\w): (?<password>\w+)$/

    def parse(input) do
      matches = Regex.named_captures(@matcher, input)

      policy = %Policy{
        char: matches["char"],
        pos1: String.to_integer(matches["pos1"]),
        pos2: String.to_integer(matches["pos2"])
      }

      %Entry{
        policy: policy,
        password: matches["password"]
      }
    end

    def valid?(entry = %Entry{}) do
      char1 = String.at(entry.password, entry.policy.pos1 - 1)
      char2 = String.at(entry.password, entry.policy.pos2 - 1)

      bool_xor(char1 == entry.policy.char, char2 == entry.policy.char)
    end

    defp bool_xor(a, b) do
      if a == b, do: false, else: true
    end
  end
end

count_part1 = File.stream!(hd System.argv)
        |> Enum.map(&Part1.Entry.parse/1)
        |> Enum.filter(&Part1.Entry.valid?/1)
        |> Enum.count

count_part2 = File.stream!(hd System.argv)
        |> Enum.map(&Part2.Entry.parse/1)
        |> Enum.filter(&Part2.Entry.valid?/1)
        |> Enum.count

IO.inspect(count_part1)
IO.inspect(count_part2)
