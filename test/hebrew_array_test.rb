require 'test_helper'
require 'hebrew_array'

class HebrewArrayTest < ActiveSupport::TestCase

  test "should init empty" do
    array = HebrewArray.new
    assert array.empty?
  end

  test "should transliterate single word" do
    array = HebrewArray.new
    array << "תְּפִילָה"
    assert_equal array.transliterate(:single), {"תְּפִילָה"=>["tefiloh"]}
  end

  test "should transliterate many words" do
    array = HebrewArray.new
    %w(תְּשׁוּבָה תְּפִילָה צְדָקַה).each { |i| array << i }
    assert_equal array.transliterate(:single), {"תְּשׁוּבָה"=>["teshuvoh"], "תְּפִילָה"=>["tefiloh"], "צְדָקַה"=>["tzedokah"]}
  end
end
