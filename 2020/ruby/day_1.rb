# frozen_string_literal: true

input = ARGF.readlines.map(&:to_i)

[2, 3].each do |size|
  p input.permutation(size)
         .lazy
         .reject { |s| s[0] + s[1] > 2020 }
         .select { |s| s.sum == 2020 }
         .first
         .reduce(:*)
end
