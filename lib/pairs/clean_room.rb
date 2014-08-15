class Pairs
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
