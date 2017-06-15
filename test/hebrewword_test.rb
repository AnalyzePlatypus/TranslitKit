require 'test_helper'
require 'hebrewword'
require 'phonemizer'

class HebrewWordTest < ActiveSupport::TestCase

  test "correctly stores the hebrew word" do
    @heb = HebrewWord.new "שׁבּת"
    assert_equal @heb.raw, "שׁבּת"
    assert_equal @heb.to_s, "שׁבּת"
  end


  test "should transliterate a word" do
    @heb = HebrewWord.new "בְּרֵאשִׁית"
    assert_equal ["bereishis"], @heb.transliterate(:single)

    @heb = HebrewWord.new "תְּשׁוּבָה"
    assert_equal ["teshuvoh"], @heb.transliterate(:single)

    @heb = HebrewWord.new "אַברָהָם"
    assert_equal ["avroom", "avroam", "avroem", "avrohom", "avroham", "avrohem", "avraom", "avraam", "avraem", "avrahom", "avraham", "avrahem", "avreom", "avream", "avreem", "avrehom", "avreham", "avrehem"],
                @heb.transliterate(:short)
  end

  test "should reject unknown phoneme_map names" do
    @heb = HebrewWord.new "אַברָהָם"
    assert_raises(RuntimeError) { @heb.transliterate(:blah) }
  end

  test "`phonemes` is delegated to the Phonemizer class" do
    @heb = HebrewWord.new "אַברָהָם"
    assert_equal @heb.phonemes, Phonemizer.new(@heb.raw).phonemes
  end

  test "method `t` alias for `transliterate`" do
    @heb = HebrewWord.new "אַברָהָם"
    assert_equal @heb.transliterate(:single), @heb.t(:single)
  end

  test "`inspect` function outputs correct translit counts" do
    @heb = HebrewWord.new "אַברָהָם"
    assert_equal @heb.inspect, "אַברָהָם: Permutations: #{@heb.transliterate(:single).length} single | #{@heb.transliterate(:short).length} short | #{@heb.transliterate(:long).length} long"
  end
end
