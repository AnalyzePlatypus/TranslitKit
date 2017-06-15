=begin
  Phonemizer.rb

  Takes a raw Hebrew word (with nekudos)
  and returns an array of phonemes.

  Behavior:
  * Letters and nekudos are seperated.
  * Strips spaces
  * Normalizes CHATAF nekudos
  * Normalizes final letters
  * The DAGESH is joined to its letter
  * The SHIN's dot is attached to the SHIN
  * MALEI nekudos are stripped of their extra YUD

=end


require 'permuter'
require 'phoneme_maps'

# Constants

# English and Hebrew Unicode have different space (' ') characters
ENGLISH_SPACE = [160].pack "U"
HEBREW_SPACE = [32].pack "U"

# Edge-case characters
DAGESH   = "ּ"
SHIN_DOT = "ׁ"

# Nekudos that have special cases
CHOLOM   = "ֹ"
PATACH   = "ַ"
CHIRIK   = "ִ"
TZEIREI  = "ֵ"

# Letters that have special cases
SIN      = "ש"
VAV      = "ו"
CHES     = "ח"
YUD      = "י"
SHIN_WITH_DOT = "שׁ"


# Regexes
LETTER       = /[אבגדהוזחטיכלמנסעפקרשתםןץףךצ]/
FINAL_LETTER = /[םןךףץ]/
CHATAF       = ['ֲ','ֳ','ֱ']
DAGESH_WHITELIST = /[בוכפת]/


# Breaks a Hebrew string into its discrete phonemes
class Phonemizer

  def initialize word
    @hebword = word
  end

  # Returns the unedited Hebrew string
  def raw
    @hebword
  end

  # Breaks the word down into its discrete phonemes
  # “ם’’ ,“וּ“ ,“כּ“ ,“ע“] = "עַכּוּם]
  #
  # No arguments; returns an array
  #
  # This function depends heavily on the workings of Hebrew grammer,
  # so it gets a bit complicated. If you have a more elegant solution, I'd gladly take it.
  # This thing was a hornet's nest full of bugs, so watch that test suite when editing!
  def phonemes
        @completed = []

        # For each raw character :
        @hebword.chars.each_with_index do |char,i|

          # Skip whitespace
          if char == ENGLISH_SPACE || char == HEBREW_SPACE
            next

          # If it's a final letter, normalize it to its standard form (מ –> ם)
          elsif char =~ FINAL_LETTER
            @completed << normalize_final_letter(char)

          # If it's a CHATAF, normalize it to it's standard form
          elsif CHATAF.include? char
            @completed << deCHATAFize(char)

          # If it's a SHIN_DOT, find the previous SIN and replace it with SHIN_WITH_DOT
          elsif char == SHIN_DOT
            @completed[@completed.rindex(SIN)] = SHIN_WITH_DOT

          # If it's a DAGESH:
          # 1. Find the previous letter
          # 2. Check if it's on the list of DAGESH-compatible letters
          # 3. If it is, add it
          # 4. If it's not, implicitly fall through to the `else` case
          elsif char == DAGESH
            previous_letter = previous_letter_index(i, @completed)
            if previous_letter.nil? then raise "Orphaned DAGESH: DAGESH at position #{i} is not preceded by a letter.(Word: \"#{@hebword}\")"; end
            if DAGESH_WHITELIST =~ @completed[previous_letter]
              @completed[previous_letter] += DAGESH
            end

          # Skip the VAV of a CHOLOM MALEI, otherwise add it
          elsif char == VAV
            @hebword[i + 1] == CHOLOM ? next : @completed << VAV

          # Skip the YUD of a CHIRIK MALEI and TZEIREI MALEI, otherwise add them
          elsif char == YUD
            (@completed.last == CHIRIK ||
             @completed.last == TZEIREI) ?
                next : @completed << YUD

          # Append a PATACH to a final CHES  ( חַ )
          elsif char == PATACH &&          # It's a PATACH
              @completed.last == CHES &&   # Proceeded by a CHES
              (i == @hebword.length - 1)   # At the end of the word
           @completed[@completed.length - 1] += PATACH

          # Otherwise, pass the letter or nekuda unchanged
          else
            @completed << char
          end

        end # end loop
        @completed

  end

  private


    # Normalize final letters to standard forms
    def normalize_final_letter char
      case char
        when "ם" then return "מ"
        when "ן" then return "נ"
        when "ץ" then return "צ"
        when "ף" then return "פ"
        when "ך" then return "כ"
        else
          raise "#{char} is not a final letter\nSuggested test snippet: #{FINAL_LETTER} =~ #{char}\n"
      end
    end

    # Normalize CHATAF nekudos to standard forms
    # Raises a `RuntimeError` if the character is not one of ['ֲ','ֳ','ֱ']
    def deCHATAFize chataf
      case chataf
        when "ֲ" then return "ַ"
        when "ֳ" then return "ָ"
        when "ֱ" then return "ֶ"
      end
      raise "#{chataf} is not a CHATAF\n\tSuggested test snippet: ['ֲ','ֳ','ֱ'].include?(#{chataf})"
    end

    # Return the index of the first previous character that is a letter
    #  * If the index is a letter            -> Ignore it and find the previous one #BugOrFeature?
    #  * If a previous character is a letter -> return its index
    #  * If no characters are letters        -> nil
    def previous_letter_index current_loc, array
      current_loc.downto(0) do |i|
        return i if array[i] =~ LETTER
      end
      nil
    end
end
