require 'within_time/bsearch_with_local_jumping'
require 'rails_compatibility/pick'

module WithinTime
  class BSearchService
    def initialize(relation)
      @relation = relation
    end

    # Make sure the model satisfies the following conditions:
    #   1. [column] is monotonic increasing (when order by id ASC).
    def bsearch_time_range(column, time_range)
      first_id = RailsCompatibility.pick(@relation.order(id: :asc), :id)
      return none if !first_id

      last_id = RailsCompatibility.pick(@relation.order(id: :desc), :id)

      min_id_in_time_range = bsearch_first_id_on_datetime(first_id..last_id, time_range.min, column)
      return none if min_id_in_time_range == nil

      max_id_in_time_range = bsearch_last_id_on_datetime(min_id_in_time_range..last_id, time_range.max, column)
      return @relation.where('id >= ?', min_id_in_time_range) if max_id_in_time_range == nil
      return @relation.where(id: min_id_in_time_range...max_id_in_time_range)
    end

    def bsearch_first_id_on_datetime(id_range, datetime, column)
      BSearchWithLocalJumping::RangeWrapper.new(id_range).search do |id|
        value, actual_id = RailsCompatibility.pick(@relation.where('id <= ?', id).order(id: :desc), column, :id)
        next [value >= datetime, actual_id]
      end
    end

    def bsearch_last_id_on_datetime(id_range, datetime, column)
      BSearchWithLocalJumping::RangeWrapper.new(id_range).search do |id|
        value, actual_id = RailsCompatibility.pick(@relation.where('id >= ?', id).order(id: :asc), column, :id)
        next [value > datetime, actual_id]
      end
    end
  end
end
