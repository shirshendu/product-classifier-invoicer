require_relative 'product'
require_relative 'product_classifier'

module ProductFactory
  def self.create product_text
    # Parsing
    desc, cost = product_text.split("@")
    cost.to_f
    desc.strip
    array_desc = desc.split
    qty = array_desc.shift
    desc = array_desc.join " "

    # Classification
    product_type = ProductClassifier.type(array_desc)

    # Creation
    product = product_type.new qty.to_f, desc, cost.to_f
  end
end

