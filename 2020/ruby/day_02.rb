# frozen_string_literal: true

class BaseEntry
  attr_accessor :rule, :password

  def initialize(rule, password)
    @rule = rule
    @password = password
  end

  def self.parse
    raise NotImplementedError
  end

  def valid?
    raise NotImplementedError
  end
end

module Part1
  Rule = Struct.new(:char, :min, :max)

  class Entry < BaseEntry
    RULE_MATCHER = /(?<min>\d+)-(?<max>\d+)\s+(?<char>\w): (?<password>\w+)$/.freeze

    def self.parse(input)
      matches = input.match(RULE_MATCHER)
      rule = Rule.new(matches[:char], matches[:min].to_i, matches[:max].to_i)
      new(rule, matches[:password])
    end

    def valid?
      count = @password.count(@rule.char)
      count >= @rule.min && count <= @rule.max
    end
  end
end

module Part2
  Rule = Struct.new(:char, :pos1, :pos2)

  class Entry < BaseEntry
    RULE_MATCHER = /(?<pos1>\d+)-(?<pos2>\d+)\s+(?<char>\w): (?<password>\w+)$/.freeze

    def self.parse(input)
      matches = input.match(RULE_MATCHER)
      rule = Rule.new(matches[:char], matches[:pos1].to_i, matches[:pos2].to_i)
      new(rule, matches[:password])
    end

    def valid?
      char1 = password[@rule.pos1 - 1]
      char2 = password[@rule.pos2 - 1]

      (char1 == @rule.char) ^ (char2 == @rule.char)
    end
  end
end

count_part1 = 0
count_part2 = 0

ARGF.each_line do |line|
  count_part1 += 1 if Part1::Entry.parse(line).valid?
  count_part2 += 1 if Part2::Entry.parse(line).valid?
end

p count_part1
p count_part2
