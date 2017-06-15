require 'test_helper'
require 'phoneme_maps'

class PhonemeMapsTest < ActiveSupport::TestCase

  def setup
    @p = PhonemeMaps.new
  end


  test "should load files in directory without blowing up" do
    # Fetch all the filenames
    filenames = Dir.new(@p.directory).entries.select {|f| f.include? '.json'}
    # Strip the '.json' extension and convert to symbols
    symbols = filenames.map {|f|  f.sub(".json", '').to_sym }

    assert_nothing_raised do
      symbols.each {|s| @p.load s}
    end
  end

  test "should reject unknown file list names" do
    assert_raises (RuntimeError) {@p.load :pan_galactic_gargle_blaster}
  end

  test "should reject malformed JSON files" do
    assert_raises (RuntimeError) {@p.validate_json "{'missing_brace': true"}
  end 
end
