class Pairs
  attr_reader :max_attempts, :block

  def initialize(max_attempts: 1000, &block)
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

        next unless clean_room.__constraints__.all? { |constraint|
          constraint.call(these)
        }

        result << these

        these.each do |item|
          all.delete item
        end
      end

      return result
    end
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

    def method_missing(method_name, *args, &block)
      return super unless args.count == 1

      __items__[method_name] ||= []
      __items__[method_name] << args.first
    end
  end
end
