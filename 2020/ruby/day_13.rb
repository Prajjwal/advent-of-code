# frozen_string_literal: true

require_relative 'lib/chinese_remainder'

input = ARGF.readlines.map(&:chomp)

class Bus
  attr_accessor :id, :departure

  def initialize(id)
    @id = id.to_i
    @departure = @id
  end
end

# Part 1

start_time = input[0].to_i
buses = input[1].split(/,/).filter_map do |bus_id|
  Bus.new(bus_id) unless bus_id == 'x'
end

while true
  behind_schedule = buses.reject { |bus| bus.departure >= start_time }

  break if behind_schedule.empty?

  behind_schedule.map { |bus| bus.departure += bus.id }
end

first_bus = buses.min_by(&:departure)
p (first_bus.departure - start_time) * first_bus.id # => 174

# Part 2

departure_offsets = []

input[1].split(/,/).filter_map.with_index do |bus_id, index|
  departure_offsets << index * -1 unless bus_id == 'x'
end

p ChineseRemainder.solve(buses.map(&:id), departure_offsets) # => 780601154795940
