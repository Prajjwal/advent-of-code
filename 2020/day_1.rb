# frozen_string_literal: true

input = ARGF.readlines.map(&:to_i)

[2, 3].each do |size|
  p input.permutation(size)
         .lazy
         .select { |s| s.sum == 2020 }
         .first
         .reduce(:*)
end
