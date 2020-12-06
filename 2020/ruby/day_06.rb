# frozen_string_literal: true

class Group
  def initialize(answers)
    @answers = answers.join('').split('')
    @size = answers.size
  end

  def self.parse(answers)
    new(answers.split("\n"))
  end

  def everyone_agrees_on
    @answers.tally.select { |_k, v| @size == v }
  end

  def someone_agrees_on
    @answers.uniq
  end
end

groups = ARGF.read.split("\n\n").map { |chunk| Group.parse(chunk) }

# Part 1
p groups.map(&:someone_agrees_on).sum(&:size)  # => 6947

# Part 2
p groups.map(&:everyone_agrees_on).sum(&:size) # => 3398
