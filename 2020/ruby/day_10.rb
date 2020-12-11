# frozen_string_literal: true

input = ARGF.readlines.map(&:chomp).reject(&:empty?).map(&:to_i)

adapters = [0] + input.sort + [input.max + 3]

# Part 1

diffs = adapters.each_cons(2).with_object(Hash.new(0)) do |cell, diffs|
  a, b = cell
  diffs[b - a] += 1
end

p diffs[1] * diffs[3] # => 2170

# Part 2

# $cache[int] => the number of valid chains after this adapter is plugged in.
$cache = { adapters.last => 1 }

def count_arrangements(adapters, current)
  adapters
    .select { |a| (1..3).include?(a - current) }
    .sum { |a| $cache[a] ||= count_arrangements(adapters, a) }
end

p count_arrangements(adapters, 0) # => 24803586664192
