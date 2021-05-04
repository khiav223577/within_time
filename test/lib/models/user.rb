# frozen_string_literal: true
class User < ActiveRecord::Base
  if Gem::Version.new(ActiveRecord::VERSION::STRING) >= Gem::Version.new('5.0.0')
    scope :created_within, WithinTime.build_scope(column: :created_at, has_index: true)
  else
    scope :created_within, WithinTime.build_scope(column: :created_at, has_index: true, klass: self)
  end
end
