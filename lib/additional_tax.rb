module AdditionalTax
  def self.extend_object o
    o.add_tax_type :additional_tax
    def o.additional_tax
      # calculated over and above all other taxes.
      taxable_cost = cost
      @applicable_taxes.each do |tax|
        taxable_cost += self.send(tax) unless tax == :additional_tax
      end
      (taxable_cost) * 0.024
    end
  end
end
