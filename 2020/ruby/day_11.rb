# frozen_string_literal: true

input = ARGF.readlines.map(&:chomp).reject(&:empty?).map { |line| line.split // }

class World
  attr_accessor :seats, :size_x, :size_y

  DIRECTIONS = [
    [1, 1], [1, 0], [1, -1], [0, 1],
    [0, -1], [-1, 1], [-1, 0], [-1, -1]
  ].freeze

  def initialize(seats, threshold: 4)
    @seats = seats
    @size_x = seats.first.size
    @size_y = seats.size
    @threshold = threshold
  end

  def pretty_print
    puts @seats.map { |row| row.join('') }
  end

  def dup
    World.new(@seats.map(&:dup), threshold: @threshold)
  end

  def next_world
    world = dup

    each_index do |row, col|
      num_occupied = occupied_neighbors(row, col)

      next if floor?(row, col)

      if empty?(row, col) && num_occupied == 0
        world.set(row, col, '#')
      end

      if occupied?(row, col) && num_occupied >= @threshold
        world.set(row, col, 'L')
      end
    end

    world
  end

  def simulation
    Enumerator.produce(self) do |world|
      world.next_world
    end
  end

  def occupied_neighbors(row, col)
    # Don't use World#adjacents, memory hog.
    DIRECTIONS.count do |di, dj|
      i, j = row + di, col + dj

      !out_of_bounds?(i, j) && occupied?(i, j)
    end
  end

  def occupied
    count = 0

    @seats.each do |row|
      row.each do |col|
        count += 1 if col == '#'
      end
    end

    count
  end

  def set(row, col, value)
    @seats[row][col] = value
  end

  def get(row, col)
    @seats[row][col]
  end

  def ==(world)
    @seats == world.seats
  end

  def out_of_bounds?(row, col)
    row < 0 || col < 0 || row >= @size_y || col >= @size_x
  end

  def floor?(row, col)
    get(row, col) == '.'
  end

  def seat?(row, col)
    !floor?(row, col)
  end

  def occupied?(row, col)
    get(row, col) == '#'
  end

  def empty?(row, col)
    get(row, col) == 'L'
  end

  def each_index
    (0...@size_y).each do |row|
      (0...@size_x).each do |col|
        yield [row, col]
      end
    end
  end
end

# Find the first world in the simulation that was unchanged from the last.
final_world = World.new(input).simulation.reduce do |old, new|
  break new if old == new
  new
end

p final_world.occupied # => 2275

# Part 2

class World
  # A neighbor is now defined as the first seat visible in any of the 8
  # directions.
  def occupied_neighbors(row, col)
    DIRECTIONS.count do |di, dj|
      i, j = row, col

      loop do
        i += di
        j += dj

        break if out_of_bounds?(i, j) || seat?(i, j)
      end

      occupied?(i, j) unless out_of_bounds?(i, j)
    end
  end
end

final_world = World.new(input, threshold: 5).simulation.reduce do |old, new|
  break new if old == new
  new
end

p final_world.occupied # => 2121
