module ValueAddedTax
  def self.extend_object o
    o.add_tax_type :value_added_tax
    def o.value_added_tax
      0.125 * cost
    end
  end
end

module VatExempt
  def self.extend_object o
    o.remove_tax_type :value_added_tax
  end
end
