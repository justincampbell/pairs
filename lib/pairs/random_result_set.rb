class Pairs
  class RandomResultSet
    attr_reader :values

    def initialize(values)
      @values = values
    end

    def pairs
      @pairs ||= begin
        all = values.dup
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
    end

    def satisfies?(constraints)
      constraints.all? { |constraint|
        pairs.all? { |pair|
          constraint.call(pair)
        }
      }
    end
  end
end
