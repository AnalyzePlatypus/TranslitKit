=begin
  HebrewWord.rb

  Wraps a Hebrew word.

  Methods:
    * raw -> returns the original word
    * to_s -> Alias to `raw`
    * phonemes -> Returns an Array of phonemes (see Class::Phonemizer)
    * transliterate(list_name) -> Returns as Array of transliterated strings
    * t -> Alias for `transliterate`
    * inspect -> Returns an informative string of the original Hebrew, and the available translit counts

=end

require 'phoneme_maps'
require 'phonemizer'
require 'transliterator'

# The user-facing transliterator class
class HebrewWord

  # Initializer
  # Expects a Unicode Hebrew word (i.e. "עַקֵדָה")
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
