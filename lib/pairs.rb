class Pairs
  attr_reader :block

  def initialize(&block)
    @block = block
  end

  def solve!
    clean_room.instance_exec(&block)

    all = clean_room.__items__.values.flatten
    result = []

    until all.empty?
      these = all.sample(2)
      result << these

      these.each do |item|
        all.delete item
      end
    end

    result
  end

  def solution
    @solution ||= solve!
  end

  private

  def clean_room
    @clean_room ||= CleanRoom.new
  end

  class CleanRoom
    def __items__
      @__items__ ||= {}
    end

    def method_missing(method_name, *args, &block)
      return super unless args.count == 1

      __items__[method_name] ||= []
      __items__[method_name] << args.first
    end
  end
end
