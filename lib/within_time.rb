require 'within_time/version'
require 'within_time/bsearch_with_local_jumping'

module WithinTime
  class << self
    def build_scope(column:, has_index: false)
      ->(time_range){ WithinTime.bsearch_time_range(self, column, time_range) }
    end

    # Make sure the model satisfies the following conditions:
    #   1. [column] is monotonic increasing (when order by id ASC).
    def bsearch_time_range(relation, column, time_range)
      first_id = relation.order(id: :asc).pick(:id)
      return none if !first_id

      last_id = relation.order(id: :desc).pick(:id)

      min_id_in_time_range = bsearch_first_id_on_datetime(relation, first_id..last_id, time_range.min, column)
      return none if min_id_in_time_range == nil

      max_id_in_time_range = bsearch_last_id_on_datetime(relation, min_id_in_time_range..last_id, time_range.max, column)
      return relation.where('id >= ?', min_id_in_time_range) if max_id_in_time_range == nil
      return relation.where(id: min_id_in_time_range...max_id_in_time_range)
    end

    def bsearch_first_id_on_datetime(relation, id_range, datetime, column)
      BSearchWithLocalJumping::RangeWrapper.new(id_range).search do |id|
        value, actual_id = relation.where('id <= ?', id).order(id: :desc).pick(column, :id)
        next [value >= datetime, actual_id]
      end
    end

    def bsearch_last_id_on_datetime(relation, id_range, datetime, column)
      BSearchWithLocalJumping::RangeWrapper.new(id_range).search do |id|
        value, actual_id = relation.where('id >= ?', id).order(id: :asc).pick(column, :id)
        next [value > datetime, actual_id]
      end
    end
  end
end
