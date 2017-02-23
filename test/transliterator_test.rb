require 'test_helper'

class TransliteratorTest < ActiveSupport::TestCase

  test "should require a string on init" do
    assert_raise (ArgumentError) { Transliterator.new }
  end

  test "should init without blowing up" do
    assert_nothing_raised {Transliterator.new "תְּשׁוּבָה"}
  end

  test "should not change supplied test" do
    assert_equal "תְּשׁוּבָה", Transliterator.new("תְּשׁוּבָה").raw
    assert_equal "תְּשׁוּבָה", Transliterator.new("תְּשׁוּבָה").to_s
  end

  test "should correctly find phonemes" do
    assert_equal ["תּ", "ְ", "שׁ", "וּ", "ב", "ָ", "ה"], Transliterator.new("תְּשׁוּבָה").phonemes
  end

  test "should select 'short' list by default" do
    assert_equal :short, Transliterator.new("תְּשׁוּבָה").phoneme_map
  end

  test "should remember the list named during init" do
    t = Transliterator.new("תְּשׁוּבָה", :single)
    assert_equal :single, t.phoneme_map
  end

  test "should remember the list selected during init even after transliteration" do
    t = Transliterator.new("תְּשׁוּבָה", :single)
    t.transliterate
    assert_equal :single, t.phoneme_map
  end

  test "should transliterate with stored list by default" do
    t = Transliterator.new("תְּשׁוּבָה")
    assert_equal :short, t.phoneme_map
    assert_equal t.transliterate, ["tashuvo", "tashuvoh", "tashuva", "tashuvah", "tashuve", "tashuveh", "tashoovo", "tashoovoh", "tashoova", "tashoovah", "tashoove", "tashooveh", "tasheuvo", "tasheuvoh", "tasheuva", "tasheuvah", "tasheuve", "tasheuveh", "teshuvo", "teshuvoh", "teshuva", "teshuvah", "teshuve", "teshuveh", "teshoovo", "teshoovoh", "teshoova", "teshoovah", "teshoove", "teshooveh", "tesheuvo", "tesheuvoh", "tesheuva", "tesheuvah", "tesheuve", "tesheuveh", "tishuvo", "tishuvoh", "tishuva", "tishuvah", "tishuve", "tishuveh", "tishoovo", "tishoovoh", "tishoova", "tishoovah", "tishoove", "tishooveh", "tisheuvo", "tisheuvoh", "tisheuva", "tisheuvah", "tisheuve", "tisheuveh", "t'shuvo", "t'shuvoh", "t'shuva", "t'shuvah", "t'shuve", "t'shuveh", "t'shoovo", "t'shoovoh", "t'shoova", "t'shoovah", "t'shoove", "t'shooveh", "t'sheuvo", "t'sheuvoh", "t'sheuva", "t'sheuvah", "t'sheuve", "t'sheuveh"]

    t = Transliterator.new("תְּשׁוּבָה", :single)
    assert_equal :single, t.phoneme_map
    assert_equal t.transliterate, ["teshuvoh"]
  end

  test "should fail if bad list name given" do
    assert_raise (RuntimeError) { Transliterator.new("תְּשׁוּבָה", :blah) }
    assert_raise (RuntimeError) { Transliterator.new("תְּשׁוּבָה").phoneme_map = :blah }
    assert_raise (RuntimeError) { Transliterator.new("תְּשׁוּבָה").transliterate(:blah) }
  end

  test "should change list when told to" do
    t = Transliterator.new("תְּשׁוּבָה")
    assert_equal :short, t.phoneme_map


    t.phoneme_map = :single
    assert_equal :single, t.phoneme_map
    assert_equal t.transliterate, ["teshuvoh"]
  end

  test "should use supplied list when list supplied in #transliterate" do
    t = Transliterator.new("תְּשׁוּבָה")
    assert_equal :short, t.phoneme_map

    assert_equal t.transliterate(:single), ["teshuvoh"]
  end
end
