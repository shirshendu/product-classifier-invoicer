require_relative 'value_added_tax'
require_relative 'additional_tax'
class Product
  include ValueAddedTax
  attr_accessor :name,:qty,:unit_cost

  def initialize qty, name, unit_cost
    @qty = qty
    @name = name
    @unit_cost = unit_cost
    extend AdditionalTax if imported?
  end

  def cost
    @qty * @unit_cost
  end

  def imported?
    name.downcase.include? "imported"
  end

  def == product
    product.name == @name
    product.unit_cost == @unit_cost
  end
end

# Toy data created by hand, with reference from
# https://images-na.ssl-images-amazon.com/images/G/01/rainier/help/icg/toys_item_classification_guide.html
class Toy < Product
  include VatExempt
end

# Food data created by parsing and hand-curating data from
# https://images-na.ssl-images-amazon.com/images/G/01/rainier/help/icg/grocery_item_classification_guide.html
class Food < Product
  include VatExempt
end

# Medicine data pulled in real time from
# http://www.medguideindia.com/
class Medicine < Product
  include VatExempt
end

module Imported
  include AdditionalTax
end

class ProductError < StandardError; end
