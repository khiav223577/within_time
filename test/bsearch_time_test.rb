require 'test_helper'

class BsearchTimeTest < Minitest::Test
  def setup
  end

  def test_created_within_scope
    assert_equal 3, User.where(gender: 'female').created_within(3.days.ago..1.days.from_now).count
    assert_equal 4, User.created_within(3.days.ago..1.days.from_now).count
  end
end
