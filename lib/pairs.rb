require 'pairs/clean_room'
require 'pairs/random_result_set'

class Pairs
  class NoSolutionError < StandardError; end

  attr_reader :max_attempts, :block

  MAX_ATTEMPTS = 10_000

  def initialize(max_attempts: MAX_ATTEMPTS, &block)
    @max_attempts = max_attempts
    @block = block
  end

  def solution
    @solution ||= solve!
  end

  def solve!
    clean_room.instance_exec(&block)

    max_attempts.times do
      result = RandomResultSet.new(values)
      return result.pairs if result.satisfies?(constraints)
    end

    raise NoSolutionError
  end

  def constraints
    @constraints ||= clean_room.__constraints__
  end

  def values
    @values ||= clean_room.__items__.values.flatten
  end

  private

  def clean_room
    @clean_room ||= CleanRoom.new
  end
end
