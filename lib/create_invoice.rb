#!/env/ruby

require_relative 'product_factory'
require 'table_print'
##================================
#Functions
##================================

def build_product_list input_filename
  input = File.new input_filename

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
  product_list
end

def print_product_table product_list
  tp product_list, "name","qty","unit_cost","cost"
end

def calc_totals product_list
  totals = {}
  totals[:subtotal] = 0.0
  totals[:value_added_tax] = 0.0
  totals[:additional_tax] = 0.0
  totals[:grand] = 0.0

  product_list.each do |product|
    totals[:subtotal] += product.cost
    product.applicable_taxes.each do |tax|
      totals[tax] += product.public_send(tax)
    end
    totals[:grand] += product.cost_after_tax
  end
  totals
end

# =======================
# Actual script starts
# =======================
puts
puts
puts "Product: <qty> <product name> @ <cost/unit>"

product_list = build_product_list(ARGV[0])

puts "Creating Invoice:"
print_product_table product_list

# Calculate totals and taxes
totals = calc_totals product_list

puts "\t\t\t\t\tSubTotal: #{'%.2f' % totals[:subtotal]}"
puts "\t\t\t\t\tValue Added Tax: #{'%.2f' % totals[:value_added_tax]}"
puts "\t\t\t\t\tAdditional Tax: #{'%.2f' % totals[:additional_tax]}"
puts "\t\t\t\t\tTotal: #{'%.2f' % totals[:grand]}"



