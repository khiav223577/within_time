require 'within_time/version'
require 'within_time/bsearch_service'

module WithinTime
  class << self
    def build_scope(column:, has_index: false, klass: nil)
      if klass
        service = WithinTime::BSearchService.new(klass)
        return ->(time_range){ service.bsearch_time_range(column, time_range) }
      end

      return ->(time_range){ WithinTime::BSearchService.new(self).bsearch_time_range(column, time_range) }
    end
  end
end
