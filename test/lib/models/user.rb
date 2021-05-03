# frozen_string_literal: true
class User < ActiveRecord::Base
  scope :created_within, WithinTime.build_scope(column: :created_at, has_index: true)
end
