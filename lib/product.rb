require_relative 'value_added_tax'
require_relative 'additional_tax'
class Product
  attr_accessor :name,:qty,:unit_cost,:applicable_taxes

  def initialize qty, name, unit_cost
    @qty = qty
    @name = name
    @unit_cost = unit_cost
    @applicable_taxes = []
    extend ValueAddedTax
    extend AdditionalTax if imported?
  end

  def cost
    @qty * @unit_cost
  end

  def cost_after_tax
    total_tax = 0.0
    @applicable_taxes.each do |tax_type|
      total_tax += self.send(tax_type)
    end
    cost + total_tax
  end

  def imported?
    name.downcase.include? "imported"
  end

  def == product
    product.name == @name
    product.unit_cost == @unit_cost
  end

  def remove_tax_type tax
    @applicable_taxes.delete tax.to_sym
  end

  def add_tax_type tax
    @applicable_taxes << tax.to_sym unless @applicable_taxes.index tax.to_sym
  end
end

# Toy data created by hand, with reference from
# https://images-na.ssl-images-amazon.com/images/G/01/rainier/help/icg/toys_item_classification_guide.html
class Toy < Product
  def initialize qty, name, unit_cost
    super
    extend VatExempt
  end
end

# Food data created by parsing and hand-curating data from
# https://images-na.ssl-images-amazon.com/images/G/01/rainier/help/icg/grocery_item_classification_guide.html
class Food < Product
  def initialize qty, name, unit_cost
    super
    extend VatExempt
  end
end

# Medicine data pulled in real time from
# http://www.medguideindia.com/
class Medicine < Product
  def initialize qty, name, unit_cost
    super
    extend VatExempt
  end
end

class ProductError < StandardError; end
