require 'test_helper'
require 'permuter'

class PermuterTest < ActiveSupport::TestCase

  setup do
    @p = Permuter.new
  end

  test "should return [] if no arrays added" do
    assert_equal [], @p.permutations
  end

  test "should add arrays to internal list" do
    assert @p.empty?
    @p.add_array []
    assert @p.any?
  end

  test "should remove arrays from internal list" do
    @p.add_array []
    assert @p.any?
    @p.clear
    assert @p.empty?
  end

  test "should produce single permutation if arrays have only one entry" do
    @p.add_array [1]
    @p.add_array [2]
    @p.add_array [3]
    assert_equal @p.permutations.length, 1
  end

  test "should produce all permutations for integer arrays" do
    2.times { @p.add_array [0,1] }
    assert_equal @p.permutations, ["00", "01", "10", "11"]
    @p.clear

    3.times { @p.add_array [1,2,3] }
    assert_equal @p.permutations, ["111", "112", "113", "121", "122", "123", "131", "132", "133", "211", "212", "213", "221", "222", "223", "231", "232", "233", "311", "312", "313", "321", "322", "323", "331", "332", "333"]
  end

  test "should produce permutations for Latin letters" do
    3.times { @p.add_array %w[a b c] }
    assert_equal @p.permutations, ["aaa", "aab", "aac", "aba", "abb", "abc", "aca", "acb", "acc", "baa", "bab", "bac", "bba", "bbb", "bbc", "bca", "bcb", "bcc", "caa", "cab", "cac", "cba", "cbb", "cbc", "cca", "ccb", "ccc"]
  end

  test "should produce permutations for Hebrew letters" do
    3.times { @p.add_array %w[ג ב א] }
    assert_equal @p.permutations, ["גגג", "גגב", "גגא", "גבג", "גבב", "גבא", "גאג", "גאב", "גאא", "בגג", "בגב", "בגא", "בבג", "בבב", "בבא", "באג", "באב", "באא", "אגג", "אגב", "אגא", "אבג", "אבב", "אבא", "אאג", "אאב", "אאא"]
  end

end
