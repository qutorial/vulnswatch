require 'test_helper'


class ReactionsHelperTest < ActiveSupport::TestCase

  include ReactionsHelper
  
  test "status to integer index works" do
    (1..4).each do |n|
      res = status_to_integer_index(n)
      assert res.class == Fixnum
      assert n == (res + 1)
    end

    (1..4).each do |n|
      res = status_to_integer_index(n.to_s)
      assert res.class == Fixnum
      assert n == (res + 1)
    end
    
    assert status_to_integer_index(0).nil?
    assert status_to_integer_index(5).nil?
    assert status_to_integer_index(nil).nil?
  end

end

