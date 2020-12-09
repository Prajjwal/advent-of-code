# frozen_string_literal: true

input = ARGF.readlines.map(&:chomp).reject(&:empty?)

bags = input.to_h do |line|
  matchdata = line.scan(/(?:(\d+) )?(\w+ \w+) bags?/)
  _, color = matchdata.shift
  counts = matchdata.to_h { |count, color| [color, count.to_i] }

  [color, counts]
end

# Part 1

def containers_for(color, bags)
  containers = bags.filter { |_, contents| contents.has_key?(color) }.keys

  # Containing bags are bags that can contain `color` + all bags that can
  # contain those colors.
  containers + containers.flat_map { |color| containers_for(color, bags) }
end

p containers_for('shiny gold', bags).uniq.size # => 254

# Part 2

def count_contents(color, bags)
  return 0 if color == 'no other'

  total = bags[color].values.sum
  subtotal = bags[color].map { |key, value| count_contents(key, bags) * value }.sum

  total + subtotal
end

p count_contents('shiny gold', bags) # => 6006
