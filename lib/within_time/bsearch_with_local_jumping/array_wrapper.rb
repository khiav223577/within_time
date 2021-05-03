module WithinTime
  module BSearchWithLocalJumping
    class ArrayWrapper
      include BSearchWithLocalJumping

      def initialize(array)
        @array = array
      end

      def index(value)
        @array.index(value)
      end

      def fetch(index)
        @array[index]
      end

      def size
        @array.size
      end
    end
  end
end
