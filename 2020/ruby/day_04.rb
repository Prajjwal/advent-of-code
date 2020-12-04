# frozen_string_literal: true

module Validatable
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def validations
      @validations ||= Hash.new do |hash, key|
        hash[key] = []
      end
    end

    def errors
      @errors ||= []
    end

    def clear_validations
      @validations.clear
    end

    def validate(*attrs, &block)
      raise 'wtf' unless block_given?

      attrs.each do |attr|
        validations[attr.to_sym] << block
      end
    end
  end

  def validations
    self.class.validations
  end

  def valid?
    validations.all? do |attr, rules|
      rules.all? { |rule| rule[send(attr)] }
    end
  end
end

class Passport
  include Validatable

  PERMITTED_ATTRS = %i[byr iyr eyr hgt hcl ecl pid cid].freeze
  REQUIRED_ATTRS = %i[byr iyr eyr hgt hcl ecl pid].freeze

  attr_accessor *PERMITTED_ATTRS

  def initialize(attrs = { })
    @attrs = passport_params(attrs)

    # Numeric coercion
    %i[eyr iyr byr].each do |attr|
      value = @attrs[attr]

      next unless value

      @attrs[attr] = value.to_i
    end

    @attrs.each do |k, v|
      instance_variable_set("@#{k}", v)
    end
  end

  # Valide presence of required attrs
  validate(*REQUIRED_ATTRS) { |a| a }

  def self.parse(scan)
    new(scan.split(' ').map { |pair| pair.split(':') }.to_h)
  end

  private

  def passport_params(attrs)
    attrs.to_h { |k, v| [k.to_sym, v] }
         .select { |k, _v| PERMITTED_ATTRS.include?(k) }
  end
end


class PassportScanner
  include Enumerable

  def initialize(source = ARGF)
    @source = source
    @chunks = @source.each_line
                     .lazy
                     .map(&:chomp)
                     .chunk(&:empty?)
                     .filter_map do |separator, chunk|
                       chunk.join(' ') unless separator
                     end
  end

  def each
    loop { yield @chunks.next }
  end
end

passports = PassportScanner.new.map { |scan| Passport.parse(scan) }

# Part 1
p passports.count(&:valid?) # => 206

# Part 2
class Passport
  validate(:byr) { |yr| (1920..2002).include?(yr) }
  validate(:iyr) { |yr| (2010..2020).include?(yr) }
  validate(:eyr) { |yr| (2020..2030).include?(yr) }

  validate(:hgt) { |height| /\A\d{2,3}(in|cm)\z/ =~ height }
  validate(:hgt) do |height|
    value = height.to_i

    case height[-2..-1]
    when 'cm'
      (150..193).include?(value)
    when 'in'
      (59..76).include?(value)
    end
  end

  validate(:hcl) { |color| /\A#[0-9a-f]{6}\z/ =~ color }

  validate(:ecl) do |color|
    /\A(amb|blu|brn|gry|grn|hzl|oth)\z/ =~ color
  end

  validate(:pid) { |pid| /\A\d{9}\z/ =~ pid }
end

p passports.count(&:valid?) # => 123
