require 'string_pipeline'

t = Transliterator.new
s = ["שַׁבָּת", "תְּפִילִין", "יְשרָאֵל ", "תְּשׁוּבָה"]

results = t.call s

results.each do |k,v| 
  puts "#{k}: #{v}"
end
