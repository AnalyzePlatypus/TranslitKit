=begin
  Transliterator.rb


=end

require 'permuter'
require 'phoneme_maps'
require 'phonemizer'

class Transliterator < String

  # Initializer
  # Expects a Unicode Hebrew word (i.e. "עַקֵדָה")
  # and a optional phoneme-mapping list
  def initialize string, map_name = nil
    @hebword     = string
    @phoneme_map = fetch_phoneme_map map_name
    setup_permuter
  end

  # Get the raw Hebrew text of the word (Included NIKUD)
  def raw
    @hebword
  end

  # Alias of `raw`
  def to_s
    raw
  end

  def phoneme_map
    @list_name
  end

  def phoneme_map= name
    @phoneme_map = fetch_phoneme_map name
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
  # Default is `:single`
  def transliterate list_name = nil
    self.phoneme_map = list_name
    setup_permuter()
    generate_permutations()
  end

  private

  # #fetch_phoneme_maponeme_map(list_name)
  # Returns the appropriate `phoneme_map` for transliteration
  #
  # If a name is supplied, use that
  #   options: [:long, :short, :single] (default is :short)
  #
  # Following init, if no list is supplied, the one selected in init is used.
  #
  # On init:
  #    >> name -> use name
  #    >> nil  -> use :short
  #
  # After init
  #    >> name -> use name
  #    >> nil  -> use what we've already got

  def fetch_phoneme_map list_name = nil
    if list_name.nil?
      defined?(@phoneme_map) ? (return @phoneme_map) : list_name = :short
    end

    map = PhonemeMaps.new.load list_name
    @list_name = list_name
    map
  end

  # Get all permutations for `@hebword`
  def generate_permutations
    @permuter.permutations.
      select do |pr|
        # Eliminate duplicate chars
        # At start and end of permutations
        # i.e. "avrohom"  -> keep
        #      "avrohomm" -> reject
        pr[0] != pr[1] &&                      # compare first 2 chars
        pr[pr.length - 1] != pr[pr.length - 2] # compare last  2 chars
      end
  end

  # Configures the versatile Permuter for permuting the word
  def setup_permuter
    @permuter = Permuter.new

    # Get the letters of the word
    heb_letters = self.phonemes

    # For each letter, add the array
    # of possible english letters to the permuter
    heb_letters.each do |heb_letter|
      en_letters = @phoneme_map[heb_letter]
      if en_letters.nil? then raise "Couldn't find phoneme_map entry for letter ( #{heb_letter.chars} ) in list `#{@list_name}`\nSuggested test snippet: #{@list_name == ":custom" ? @list_name : "require \'phoneme_maps\';PhonemeMaps.new.short"}['#{heb_letter}'].nil?\n" end
      @permuter.add_array en_letters
    end
  end
end
