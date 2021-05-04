require 'within_time/version'
require 'within_time/bsearch_service'

module WithinTime
  class << self
    def build_scope(klass, column:, has_index: false)
      ->(time_range){ WithinTime::BSearchService.new(klass).bsearch_time_range(column, time_range) }
    end
  end
end
