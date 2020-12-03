# frozen_string_literal: true

require 'observer'

class Map
  attr_accessor :grid, :size

  TREE = '#'

  def initialize(grid)
    @grid = grid
    @size = Struct.new(:x, :y).new(@grid.first.size, @grid.size)
  end

  def tree_at?(position)
    at(position) == TREE
  end

  def at(position)
    @grid[position.y][position.x]
  end
end

class Toboggan
  include Observable

  attr_accessor :position, :map, :trees_seen

  def initialize(map, right: 3, down: 1)
    @map = map
    @right = right
    @down = down
    @position = Struct.new(:x, :y).new(0, 0)
  end

  def move(right: @right, down: @down)
    @position.x += right
    @position.y += down

    raise StopIteration if past_slope?

    wrap_around if out_of_bounds?

    changed
    notify_observers(@position)
  end

  def slide_down_slope
    loop { move }
  end

  def wrap_around
    @position.x -= @map.size.x
  end

  def out_of_bounds?
    @position.x >= @map.size.x
  end

  def past_slope?
    @position.y >= @map.size.y
  end
end

class TreeCounter
  attr_accessor :count, :toboggan

  def initialize(map)
    @count = 0
    @map = map
  end

  def update(position)
    @count += 1 if @map.tree_at?(position)
  end
end

map = Map.new(ARGF.readlines.map(&:chomp))

# Part 1
t = TreeCounter.new(map)
toboggan = Toboggan.new(map)
toboggan.add_observer(t)
toboggan.slide_down_slope
p t.count # => 289

# Part 2
counts = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map do |right, down|
  toboggan = Toboggan.new(map, right: right, down: down)
  counter = TreeCounter.new(map)

  toboggan.add_observer(counter)

  toboggan.slide_down_slope
  counter.count
end

p counts.reduce(:*) # => 5522401584
