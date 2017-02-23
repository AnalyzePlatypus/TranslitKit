require 'test_helper'

class HebrewWordTest < ActiveSupport::TestCase

  test "correctly stores the hebrew word" do
    @heb = HebrewWord.new "שׁבּת"
    assert_equal @heb.raw, "שׁבּת"
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
end
