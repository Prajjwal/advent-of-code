# frozen_string_literal: true

class BootCode
  attr_accessor :program, :counter, :acc

  def initialize(program)
    @program = program
    @counter = 0
    @acc = 0
    @visited = []
  end

  # Execute next instruction
  def execute
    op, argument = @program[@counter]
    @visited << @counter

    case op
    when :nop
      @counter += 1
    when :acc
      @acc += argument
      @counter += 1
    when :jmp
      @counter += argument
    else
      raise 'Bad Opcode'
    end
  end

  # Might never happen!
  def run
    execute until terminated?
  end

  def run_safe
    execute until loop_detected? || terminated?
  end

  def terminates?
    run_safe
    terminated?
  end

  def terminated?
    @counter >= @program.size
  end

  def loop_detected?
    @visited.include?(@counter)
  end
end

input = ARGF.readlines
            .map(&:chomp)
            .reject(&:empty?)
            .map(&:split)
            .map { |op, argument| [op.to_sym, argument.to_i] }

# Part 1

code = BootCode.new(input)
code.run_safe
p code.acc # => 2051

# Part 2

transforms = { jmp: :nop, nop: :jmp }

(0...input.size).each do |i|
  op, argument = input[i]
  new_op = transforms[op]

  next unless new_op

  program = input.dup
  program[i] = [new_op, argument]

  code = BootCode.new(program)
  p code.acc if code.terminates? # => 2304
end
