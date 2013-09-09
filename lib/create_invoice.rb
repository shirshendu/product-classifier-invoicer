#!/env/ruby

require_relative 'product_factory'
require 'table_print'
puts
puts
puts "Product: <qty> <product name> @ <cost/unit>"

input = File.new ARGV[0]

product_list = []
# Build the list of products
while product_text = input.gets and product_text != "\n"
  retries = 0
  puts "Product: " + product_text
  begin
    product =  ProductFactory.create(product_text.strip)
  rescue ProductError => e
    puts "Error adding product, retrying"
    retries += 1
    if retries > 5
      puts "Exceeded retry limit."
      raise e
    else
      retry
    end
  end

  index = product_list.index product
  if index
    product_list[index].qty += product.qty
  else
    product_list << product
  end
end

puts "Creating Invoice:"
tp product_list, "name","qty","unit_cost","cost"

# Calculate totals and taxes
subtotal = product_list.inject(0.0){|sum,i| sum + i.cost}
vat = product_list.inject(0.0){|sum,i| sum + i.value_added_tax if i.respond_to? :value_added_tax}
addl_tax = 0.0

product_list.each do |product|
  begin
    addl_tax += product.additional_tax
  rescue NoMethodError # For products that aren't imported
  end
end

total = subtotal + vat + addl_tax

puts "\t\t\t\t\tSubTotal: #{'%.2f' % subtotal}"
puts "\t\t\t\t\tValue Added Tax: #{'%.2f' % vat}"
puts "\t\t\t\t\tAdditional Tax: #{'%.2f' % addl_tax}"
puts "\t\t\t\t\tTotal: #{'%.2f' % total}"