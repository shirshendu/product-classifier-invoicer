require 'active_support/inflector'

# Misc. script for processing food data

a = File.new "./data/prelim_food"
b = File.new "./data/food", "w"
uniq_hash = {} # Hash for faster lookup times
while term = a.gets
  arr = term.split "-"
  arr.each do |each_term|
    uniq_hash[each_term.downcase.singularize.to_sym] = nil
  end
end
uniq_hash.keys.each do |key|
  b.puts key
end
b.close
a.close
