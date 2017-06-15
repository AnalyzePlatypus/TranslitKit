require 'test_helper'
require 'phonemizer'

class PhonemizerTest < ActiveSupport::TestCase


  # STORAGE

  test"correctly stores the hebrew word" do
    @phon = Phonemizer.new "שׁבּת"
    assert_equal @phon.raw, "שׁבּת"
  end

  # UNCHANGED CHARACTERS

  test "should pass normal characters unchanged" do
    @phon = Phonemizer.new "א"
    assert_equal ["א"], @phon.phonemes
  end

  test "should pass standard nekudos unchanged" do
    @phon = Phonemizer.new "ְ ֶ ֻ ָ ַ ֵ ִ "
    assert_equal ["ְ", "ֶ", "ֻ", "ָ", "ַ", "ֵ", "ִ"], @phon.phonemes
  end

  # Word splitting

  test "should seperate letters" do
    @phon = Phonemizer.new "אבג"
    assert_equal ["א", "ב", "ג"], @phon.phonemes
  end

  test "should seperate letters and nekudos" do
    @phon = Phonemizer.new "דָג"
    assert_equal ["ד", "ָ", "ג"], @phon.phonemes
  end

  # Altered characters

  test "should strip spaces" do
    utf8_en_space = [160].pack "U"
    utf8_he_space  = [32].pack  "U"

    @phon = Phonemizer.new utf8_en_space
    assert_equal [], @phon.phonemes

    @phon = Phonemizer.new utf8_he_space
    assert_equal [], @phon.phonemes
  end

  # Normalize exotic characters

  # Final Letters
  test "should normalize final letters" do
    @phon = Phonemizer.new "םןץףך"
    assert_equal ["מ", "נ", "צ", "פ", "כ"], @phon.phonemes
  end

  test "should raise an error when final-letter normalizer is given a standard letter" do
    @phon = Phonemizer.new ''
    "אבגדהוזחטיכלמנסעפקרשתצ".split('').each do |letter|
      assert_raises (RuntimeError) {@phon.send :normalize_final_letter, letter}
    end
  end


  # CHATAF nekudos

  test "should normalize CHATAF nekudos" do
    @phon = Phonemizer.new " ֲ ֳ ֱ"
    assert_equal ["ַ", "ָ", "ֶ"], @phon.phonemes
  end

  test "should raise an error when the CHATAF-nekuda normalizer is given a standard nekuda" do
    @phon = Phonemizer.new ''
    ["ְ", "ֶ", "ֻ", "ָ", "ַ", "ֵ", "ִ"].each do |nekuda|
      assert_raises (RuntimeError) {@phon.send :deCHATAFize, nekuda}
    end
  end

  # 'Full' nekudos

  test "should normalize a full chirik ( אִי –> אִ)" do
    @phon = Phonemizer.new "אִי"
    assert_equal ["א", "ִ"], @phon.phonemes
  end

  test "should normalize a full TZEIREI ( אֵי –> אֵ )" do
    @phon = Phonemizer.new "אֵי"
    assert_equal ["א", "ֵ"], @phon.phonemes
  end

  test "should normalize a full CHOLOM ( וֹ –> ֹ  )" do
    @phon = Phonemizer.new "וֹ"
    assert_equal ["ֹ"], @phon.phonemes
  end

# Bad seperations

    test "should not separate a shin and its dot (שׁ) " do
      @phon = Phonemizer.new "שׁ"
      assert_equal ["שׁ"], @phon.phonemes
    end

    test "should not seperate a CHES and PATACH when they end the word (חַ)" do
      # As in פותחַ
      @phon = Phonemizer.new "חַ"
      assert_equal ["חַ"], @phon.phonemes

      @phon = Phonemizer.new "חַחַ"
      assert_equal ["ח", "ַ", "חַ"], @phon.phonemes
    end

# DAGESH!

  test "should strip DAGESH from unchanging letters" do
    @phon = Phonemizer.new "אּבּגּדּהּוּזּחּטּיּכּלּמּנּסּעּפּצּקּרּשּשּׁתּ"
    assert_equal ["בּ", "וּ", "כּ", "פּ", "תּ"], @phon.phonemes.select {|l| l.chars.include? "ּ"}
  end

  test "should not separate a DAGESH from its letter" do
    @phon = Phonemizer.new "בּוּכּפּתּ"
    assert_equal ["בּ", "וּ", "כּ", "פּ", "תּ"], @phon.phonemes
  end

  test "should not separate a DAGESH from its letter even separated by nekuda" do
    @phon = Phonemizer.new "בַּ"
    assert_equal ["בּ","ַ"], @phon.phonemes
  end

  test "should move DAGESH to correct letter" do
    @phon = Phonemizer.new "פבּ"
    assert_equal ["פ","בּ"], @phon.phonemes
  end

  test "should move DAGESH even when proceeded by nekuda" do
      @phon = Phonemizer.new "פָבּ"
      assert_equal ["פ", "ָ", "בּ"], @phon.phonemes
  end

  test "should move DAGESH even when followed by nekuda" do
      @phon = Phonemizer.new "בָּא"
      assert_equal ["בּ", "ָ", "א"], @phon.phonemes
  end

  test "should move DAGESH even when proceeded by SHIN ( שׁ )" do
    @phon = Phonemizer.new "שׁבּ"
    assert_equal ["שׁ", "בּ"], @phon.phonemes
  end

  test "should move DAGESH to VAV" do
    @phon = Phonemizer.new "אוּ"
    assert_equal ["א", "וּ"], @phon.phonemes
  end

  test "should raise error if DAGESH has no preceding letter (Orphaned DAGESH)" do
    @phon = Phonemizer.new 'ּ'
    assert_raises (RuntimeError) { @phon.phonemes }
  end

  # ==========================
  # The internal index-finding helper method

  test "should correctly identify the previous letter in raw hebrew string" do
    # 'Returns the correct index'
    word = "שַׁבָּת"
    # word.chars.each_with_index {|c,i| puts "[#{i}]: \"#{c}\""}
    #[0]: "ש"
    #[1]: "ׁ"
    #[2]: "ַ"
    #[3]: "ב"
    #[4]: "ּ"
    #[5]: "ָ"
    #[6]: "ת"

    @phon = Phonemizer.new ""

    assert_equal 6, @phon.send(:previous_letter_index, 6, word)
    assert_equal 3, @phon.send(:previous_letter_index, 5, word)
    assert_equal 3, @phon.send(:previous_letter_index, 4, word)
    assert_equal 3, @phon.send(:previous_letter_index, 3, word)
    assert_equal 0, @phon.send(:previous_letter_index, 2, word)
    assert_equal 0, @phon.send(:previous_letter_index, 1, word)
    assert_equal 0, @phon.send(:previous_letter_index, 0, word)
  end


  test "should correctly identify the previous letter" do
    @phon = Phonemizer.new ""

    # "Returns nil when no previous Hebrew chars"
    assert_nil @phon.send(:previous_letter_index, 0, "abc")

    # "Returns the index given if the index is a char"
    assert_equal 0, @phon.send(:previous_letter_index, 0, "א")
  end


  # Full test cases

  test "should break word into phonemes" do
    @phon = Phonemizer.new "שַׁבָּת"
    assert_equal ["שׁ", "ַ", "בּ", "ָ", "ת"], @phon.phonemes

    @phon = Phonemizer.new "בְּרֵאשִׁית"
    assert_equal ["בּ", "ְ", "ר", "ֵ", "א", "שׁ", "ִ", "ת"], @phon.phonemes
  end

end
