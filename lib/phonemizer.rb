require 'permuter'
require 'phoneme_maps'

ENGLISH_SPACE = [160].pack "U"
HEBREW_SPACE = [32].pack  "U"

SHIN_DOT = "ׁ"
SHIN_WITH_DOT = "שׁ"
DAGESH   = "ּ"

CHOLOM   = "ֹ"
PATACH   = "ַ"
CHIRIK   = "ִ"
TZEIREI  = "ֵ"

SIN      = "ש"
VAV      = "ו"
CHES     = "ח"
YUD      = "י"

LETTER       = /[אבגדהוזחטיכלמנסעפקרשתםןץףךצ]/
FINAL_LETTER = /[םןךףץ]/
CHATAF       = ['ֲ','ֳ','ֱ']
DAGESH_WHITELIST = /[בוכפת]/


class Phonemizer
  def initialize word
    @hebword = word
  end

  def raw
    @hebword
  end

  # Breaks the word down into it's discrete phonemes
  # “ם’’ ,“וּ“ ,“כּ“ ,“ע“] = "עַכּוּם]
  def phonemes
        @results = []

        # For each raw character :
        @hebword.chars.each_with_index do |char,i|

          # Skip whitespace
          if char == ENGLISH_SPACE || char == HEBREW_SPACE
            next

          # Normalize final letters to their standard form
          elsif char =~ FINAL_LETTER
            @results << normalize(char)

          # Normalize CHATAF nekudos to their standard forms
          elsif CHATAF.include? char
            @results << deCHATAFize(char)

          # Append the SHIN_DOT to its SHIN
          elsif char == SHIN_DOT
            @results[@results.rindex(SIN)] = SHIN_WITH_DOT

          # Append the DAGESH to its letter
          elsif char == DAGESH
            letter_i = previous_letter_index i, @results
            @results[letter_i] += DAGESH if DAGESH_WHITELIST =~ @results[letter_i]

          # Skip the VAV of a CHOLOM MALEI, otherwise add it
          elsif char == VAV
            @hebword[i + 1] == CHOLOM ? next : @results << VAV

          # Skip the YUD of a CHIRIK MALEI and TZEIREI MALEI, otherwise add them
          elsif char == YUD
            (@results.last == CHIRIK ||
             @results.last == TZEIREI) ?
                next : @results << YUD

          # Append a PATACH to a final CHES  ( חַ )
          elsif char == PATACH &&          # It's a PATACH
              @results.last == CHES &&   # Proceeded by a CHES
              (i == @hebword.length - 1) # At the end of the word
           @results[@results.length - 1] += PATACH

          # Otherwise, pass the letter or nekuda unchanged
          else
            @results << char
          end

        end # end loop
        @results

  end

  private


    # Normalize final letters to standard forms
    def normalize char
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
