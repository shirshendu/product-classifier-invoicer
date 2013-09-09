module ValueAddedTax
  def value_added_tax
    0.125 * cost
  end
end

module VatExempt
  def value_added_tax
    0.0
  end
end
