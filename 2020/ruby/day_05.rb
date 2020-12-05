# frozen_string_literal: true

class BoardingPass
  def initialize(code)
    @code = code
  end

  def seat
    row, column = converge

    @seat = row * 8 + column
  end

  private

  def converge
    bottom, top, left, right = 0, 127, 0, 7

    @code.chars do |char|
      vmid = (top + bottom) / 2
      hmid = (left + right) / 2

      case char
      when 'F'
        top = vmid
      when 'B'
        bottom = vmid + 1
      when 'L'
        right = hmid
      when 'R'
        left = hmid + 1
      end
    end

    [top, right]
  end
end

seats = ARGF.readlines.map { |i| BoardingPass.new(i).seat }.sort

# Part 1
p seats.max # => 858

# Part 2
seat_before_gap = seats.reduce do |last, current|
  break last unless (current - last) == 1

  current
end

p seat_before_gap + 1 # => 557
