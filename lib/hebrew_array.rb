require 'hebrewword'

class HebrewArray < Array
  def << item
    if item.is_a? Array
       item.each { |i| super HebrewWord.new item }
    else
      super HebrewWord.new item
    end
  end

  def transliterate list_name = nil
    results = {}
    self.each do |word|
      results[word.to_s] = word.transliterate list_name
    end
    results
  end

end
