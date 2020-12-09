# frozen_string_literal: true

input = ARGF.readlines.map(&:chomp).reject(&:empty?).map(&:to_i)

preamble = input[1..25]
rest = input[26..]

# Part 1

first_invalid_number = until rest.empty?
  x = rest.shift
  products = preamble.combination(2).map(&:sum)

  break x unless products.include?(x)

  preamble.shift
  preamble.push(x)
end

p first_invalid_number # => 756008079

# Part 2

target = first_invalid_number

target_sequence = (0...input.size).each do |start|
  i = start
  sum = 0

  while (i <= input.size) && (sum < target)
    sum += input[i]
    i += 1
  end

  break input[start...i] if sum == target
end

p target_sequence.min + target_sequence.max # => 93727241
