# frozen_string_literal: true

module Part1
  class Ferry
    DIRECTIONS = %i[north east south west].freeze

    def initialize
      @north = 0
      @east = 0
      @facing = :east
    end

    # turn (by: x degrees)
    def turn(by: 90)
      next_direction_index = DIRECTIONS.find_index(@facing) + (by / 90).to_i
      @facing = DIRECTIONS[next_direction_index % 4]
    end

    def move(direction, steps = 1)
      case direction
      when :forward then move(@facing, steps)
      when :east then @east += steps
      when :west then @east -= steps
      when :north then @north += steps
      when :south then @north -= steps
      else raise 'Bad Direction'
      end
    end

    def manhattan_distance
      @north.abs + @east.abs
    end
  end
end

module Part2
  class Ferry < Part1::Ferry
    def initialize
      super

      @waypoint = Struct.new(:north, :east).new(1, 10)
    end

    def move_waypoint(direction, steps = 1)
      case direction
      when :east then @waypoint.east += steps
      when :west then @waypoint.east -= steps
      when :north then @waypoint.north += steps
      when :south then @waypoint.north -= steps
      end
    end

    def move(direction, steps = 1)
      return move_waypoint(direction, steps) if DIRECTIONS.include?(direction)

      raise 'Bad Direction' unless direction == :forward

      @north += @waypoint.north * steps
      @east += @waypoint.east * steps
    end

    def turn(by: 90)
      direction = by.positive? ? :clockwise : :anticlockwise

      (by.abs / 90).to_i.times { send("turn_#{direction}") }
    end

    def turn_clockwise
      @waypoint.east, @waypoint.north = @waypoint.north, @waypoint.east * -1
    end

    def turn_anticlockwise
      @waypoint.east, @waypoint.north = @waypoint.north * -1, @waypoint.east
    end
  end
end

f1 = Part1::Ferry.new
f2 = Part2::Ferry.new

ARGF.each_line do |line|
  next if line.chomp.empty?

  matchdata = /^([A-Z])(\d+)/.match line

  command = matchdata[1]
  value = matchdata[2].to_i

  [f1, f2].each do |f|
    case command
    when 'F' then f.move(:forward, value)
    when 'L' then f.turn(by: -value)
    when 'R' then f.turn(by: value)
    when 'N' then f.move(:north, value)
    when 'S' then f.move(:south, value)
    when 'E' then f.move(:east, value)
    when 'W' then f.move(:west, value)
    else raise "Malformed Command #{line}"
    end
  end
end

p f1.manhattan_distance # => 590
p f2.manhattan_distance # => 42013
