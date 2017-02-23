=begin

  PhonemeMaps.rb
  Loads phoneme_map files

  Lazily loads by default;
  The file is loaded on the first method call,
  and is cached for future calls.

  For eager loading, pass true in the initializer.

  Methods:
    * initialize(eager?)   ->
    * long
    * short
    * single
    * loaded? (:list_name)

  Test Suite:
    Complete
=end

require 'json'

FILE_DIRECTORY  = "lib/resources/"

class PhonemeMaps

# Takes a symbol, converts it into a file name,
# And attempts to load its contents
# Returns a Hash
def load symbol
  load_file "#{FILE_DIRECTORY}#{symbol.to_s}.json"
end

def directory
  FILE_DIRECTORY
end

private

  # Loads the file from the supplied location,
  # and parses it with `JSON.parse`
  # Returns a hash
  def load_file location
    begin
      f = File.open location, 'r'
      text = ""

      f.each_line {|line| text << line }

      JSON.parse text
    rescue Errno::ENOENT
      raise "Unknown list name. Could not find file `#{location[(location.rindex('/') + 1)..location.length]}` in directory `#{location[0..location.rindex('/')]}`.\nIs the file name spelled correctly, or altered somewhere in your code?"
    rescue JSON::ParserError
      raise "JSON file `#{location}` is not formatted properly.\nTry validating it at JSONlint.com (Look out for missing braces and missing/extra commas)"
    end
  end
end
