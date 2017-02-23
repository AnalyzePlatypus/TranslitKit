=begin
  HebrewWord.rb

  Wraps a Hebrew word and provides:
    * calculating transliterations

=end

require 'phoneme_maps'
require 'phonemizer'
require 'transliterator'

class HebrewWord < String

  # Initializer
  # Expects a Unicode Hebrew word (i.e. "עַקֵדָה")
  # and a optional phoneme-mapping list
  def initialize string
    @hebword = string
  end

  # Get the raw Hebrew text of the word (Included NIKUD)
  def raw
    @hebword
  end

  # Alias of `raw`
  def to_s
    raw
  end

  # Returns a `String` of format:
  # `hebrew_text`: Permutations: `x` single | `y` short | `z` long
  def inspect
    "#{@hebword}: Permutations: #{transliterate(:single).length} single | #{transliterate(:short).length} short | #{transliterate(:long).length} long"
  end

  def phonemes
    Phonemizer.new(@hebword).phonemes
  end

  # Return an `Array` of all possible transliterations of the word
  # As defined in the optional `list_name` argument. options: [:long, :short, :single]
  # Default is `:short`
  def transliterate list_name = nil
    Transliterator.new(@hebword, list_name).transliterate
  end

  # Alias for #transliterate
  def t list_name = nil
    transliterate list_name
  end
end
