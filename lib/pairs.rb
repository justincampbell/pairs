class Pairs
  class NoSolutionError < StandardError; end

  attr_reader :max_attempts, :block

  MAX_ATTEMPTS = 10_000

  def initialize(max_attempts: MAX_ATTEMPTS, &block)
    @max_attempts = max_attempts
    @block = block
  end

  def solve!
    clean_room.instance_exec(&block)

    max_attempts.times do
      all = clean_room.__items__.values.flatten
      result = []

      until all.empty?
        these = all.sample(2)

        result << these

        these.each do |item|
          all.delete item
        end
      end

      return result if clean_room.__constraints__.all? { |constraint|
        result.all? { |pair|
          constraint.call(pair)
        }
      }
    end

    raise NoSolutionError
  end

  def solution
    @solution ||= solve!
  end

  private

  def clean_room
    @clean_room ||= CleanRoom.new
  end

  class CleanRoom
    def __constraints__
      @__constraints__ ||= []
    end

    def __items__
      @__items__ ||= {}
    end

    def constraint(&block)
      __constraints__ << block
    end

    def together(a, b)
      constraint { |both| both.include?(a) ? both.include?(b) : true }
    end

    def separate(a, b)
      constraint { |both| both.include?(a) ? !both.include?(b) : true }
    end

    def alone(a)
      constraint { |both| both.include?(a) ? both == [a] : true }
    end

    def accompanied(a)
      constraint { |both| both.include?(a) ? both.count == 2 : true }
    end

    def method_missing(method_name, *args, &block)
      return super unless args.count == 1

      predicate_method_name = "#{method_name}?".intern
      unless methods.include?(predicate_method_name)
        define_singleton_method(predicate_method_name) do |item|
          __items__[method_name].include?(item)
        end
      end

      __items__[method_name] ||= []
      __items__[method_name] << args.first
    end
  end
end
