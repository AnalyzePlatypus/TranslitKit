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

lib_directory = File.dirname(__FILE__)
FILE_DIRECTORY  = "#{lib_directory}/phoneme_maps"

class PhonemeMaps

# Takes a symbol, converts it into a file name,
# And attempts to load its contents
# Returns a Hash
def load symbol
  load_file "#{FILE_DIRECTORY}/#{symbol.to_s}.json"
end

# What directory are we searching in?
def directory
  FILE_DIRECTORY
end

# Parses a string into JSON
# Raises an informative error if the JSON is malformed
def validate_json text 
  begin
    return JSON.parse text
  rescue JSON::ParserError
      raise "JSON is not formatted properly.\nTry validating it at JSONlint.com (Look out for missing braces and missing/extra commas)\n File contents: #{text}"
  end
end  

# Opens a file with `File.open`
# Raises an informative error if the file cannot be found
def open_file_safely path 
  dir = path[0..path.rindex('/')]
  filename = path[ (path.rindex('/') + 1)..path.length ]
  begin
      return File.open path, 'r' 
  rescue Errno::ENOENT
      raise "Unknown list name. Could not find file `#{filename}` in directory `#{dir}`.\n
             Is the file name spelled correctly, or altered somewhere in your code?\n
             Contents of directory:
             #{Dir.new(dir).entries}"
  end
end

private

  # Loads the file from the supplied path,
  # and parses it with `JSON.parse`
  # Returns a hash
  def load_file path
    text = ""
    open_file_safely(path).
      each_line(){|line| text << line }. 
      close
    validate_json text
  end

end
