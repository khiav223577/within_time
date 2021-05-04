require 'within_time/version'
require 'within_time/bsearch_service'

module WithinTime
  class << self
    def build_scope(column:, has_index: false, klass: nil)
      ->(time_range){ WithinTime::BSearchService.new(klass || self).bsearch_time_range(column, time_range) }
    end
  end
end
