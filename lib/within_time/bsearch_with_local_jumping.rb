require_relative 'bsearch_with_local_jumping/array_wrapper'
require_relative 'bsearch_with_local_jumping/range_wrapper'

module WithinTime
  module BSearchWithLocalJumping
    def search
      i = 0
      j = size - 1

      while i <= j
        middle = (i + j) / 2
        value = fetch(middle)

        comparison, jump_value = yield(value)
        if comparison
          middle = [middle, index(jump_value)].min
          result_idx = middle
          j = middle - 1
        else
          middle = [middle, index(jump_value)].max
          i = middle + 1
        end
      end

      return fetch(result_idx) if result_idx
    end
  end
end
