module WithinTime
  module BSearchWithLocalJumping
    class RangeWrapper
      include BSearchWithLocalJumping

      attr_reader :min

      def initialize(range)
        @range = range
        @min = @range.min
      end

      def index(value)
        value - @min
      end

      def fetch(index)
        @min + index
      end

      def size
        @range.size
      end
    end
  end
end
