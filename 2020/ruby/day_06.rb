# frozen_string_literal: true

class Group
  def initialize(size, answers)
    @size = size
    @answers = answers
  end

  def everyone_agrees_on
    @answers.tally.select { |_k, v| @size == v }
  end

  def someone_agrees_on
    @answers.uniq
  end
end

groups = ARGF.readlines
             .map(&:chomp)
             .chunk(&:empty?)
             .filter_map do |separator, chunk|
               Group.new(chunk.size, chunk.join.split('')) unless separator
             end

# Part 1
p groups.map(&:someone_agrees_on).map(&:size).sum # => 6947

# Part 2
p groups.map(&:everyone_agrees_on).map(&:size).sum # => 3398
